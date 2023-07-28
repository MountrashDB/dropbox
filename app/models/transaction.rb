# == Schema Information
#
# Table name: transactions
#
#  id           :bigint           not null, primary key
#  diterima     :boolean
#  harga        :float(24)
#  mitra_amount :float(24)
#  status       :string(255)      default("in")
#  user_amount  :float(24)
#  uuid         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  botol_id     :integer
#  box_id       :integer
#  mitra_id     :integer
#  user_id      :integer
#
class Transaction < ApplicationRecord
  include AASM
  has_one_attached :foto, dependent: :destroy, service: :cloudinary
  before_create :set_uuid
  belongs_to :mitra
  belongs_to :user
  belongs_to :box
  belongs_to :botol, optional: true

  after_create :set_balance
  before_create :send_notify
  scope :berhasil, -> { where(diterima: true) }
  after_update :reverse_balance

  def set_foto_folder(folder_name)
    # This method sets the folder for the foto attachment
    if foto.attached?
      foto.blob.update!(filename: foto.blob.filename,
                        key: "#{folder_name}/#{foto.blob.key}")
    end
  end

  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  def send_notify
    # NotifyChannel.broadcast_to self.user.uuid, status: "process"
    NotifyChannel.broadcast_to self.user.uuid,
                               status: "process",
                               message: "Memvalidasi...",
                               point: 0,
                               image: self.foto.url
  end

  def set_balance
    BotolDetectionJob.perform_at(2.seconds.from_now, self.id)
  end

  def set_balance_old
    # foto_url = Cloudinary::Utils.cloudinary_url(self.foto.key, :width => 300, :height => 300, :crop => :scale)
    # foto_url = Cloudinary::Utils.cloudinary_url(self.foto.key)
    botol_valid = Botol.validate(foto_url)
    box = Box.find(self.box_id)
    harga_botol = box.price_pcs || 65 # Nanti disesuaikan sesuai botol yang masuk
    if botol_valid
      mitra_amount = box.mitra_share * harga_botol / 100
      user_amount = box.user_share * harga_botol / 100
      investor_amount = harga_botol - mitra_amount - user_amount
      Investor.creditkan(investor_amount, "Botol")
      self.mitra_amount = mitra_amount
      self.user_amount = user_amount
      self.harga = harga_botol
      self.diterima = true
      self.save
      trx = Usertransaction.where(user_id: self.user_id).last
      description = "Reward Trx: " + self.id.to_s
      if trx
        balance = trx.balance
        user_amount = self.user_amount ? self.user_amount : 0
        trx = Usertransaction.create!(user_id: self.user_id, credit: user_amount, balance: balance + user_amount, description: description)
      else
        Usertransaction.create!(user_id: self.user_id, credit: self.user_amount, balance: self.user_amount, description: description)
      end

      trx = Mitratransaction.where(mitra_id: self.mitra_id).last
      if trx
        balance = trx.balance ? trx.balance : 0
        mitra_amount = self.mitra_amount ? self.mitra_amount : 0
        trx = Mitratransaction.create!(mitra_id: self.mitra_id, credit: mitra_amount, balance: balance + mitra_amount, description: description)
      else
        Mitratransaction.create!(mitra_id: self.mitra_id, credit: self.mitra_amount, balance: self.mitra_amount, description: description)
      end
      Box.insert_botol(self.box_id)
      NotifyChannel.broadcast_to self.user.uuid,
        status: "complete",
        image: foto_url,
        point: user_amount,
        diterima: true
    else # Invalid botol
      self.mitra_amount = 0
      self.user_amount = 0
      self.harga = harga_botol
      self.diterima = false
      self.save
      NotifyChannel.broadcast_to self.user.uuid,
                                 status: "complete",
                                 image: foto_url,
                                 point: 0,
                                 diterima: false
    end
  end

  def botol_info
    if self.botol_id
      botol = Botol.find(self.botol_id)
      if botol
        botol.jenis
      else
        nil
      end
    else
      nil
    end
  end

  def reverse_balance
    if self.diterima != self.diterima_before_last_save #Jika berubah di field diterima
      if self.diterima == false
        # Investor.debitkan(investor_amount, "Trx rejected")
        # User.find(self.user_id).debitkan(self.user_amount, "Trx rejected")
        # Mitra.find(self.mitra_id).debitkan(self.mitra_amount, "Trx rejected")
        Transaction.find(self.id).destroy
      else
        box = Box.find(self.box_id)
        mitra_amount = box.mitra_share * self.harga / 100
        user_amount = box.user_share * self.harga / 100
        investor_amount = self.harga - user_amount - mitra_amount
        # transaction = Transaction.find(self.id)
        # transaction.mitra_amount = mitra_amount
        # transaction.user_amount = user_amount
        # transaction.save
        Investor.creditkan(investor_amount, "Trx accepted")
        User.find(self.user_id).creditkan(user_amount, "Trx accepted")
        Mitra.find(self.mitra_id).creditkan(mitra_amount, "Trx accepted")
        NotifyChannel.broadcast_to self.user.uuid,
                                   status: "complete",
                                   image: self.foto.url,
                                   point: user_amount,
                                   diterima: true
      end
    end
  end
end
