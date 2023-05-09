# == Schema Information
#
# Table name: transactions
#
#  id           :bigint           not null, primary key
#  diterima     :boolean
#  harga        :float(24)
#  mitra_amount :float(24)
#  user_amount  :float(24)
#  uuid         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
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

  after_create :set_balance
  before_create :send_notify
  scope :berhasil, -> { where(diterima: true) }

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
    NotifyChannel.broadcast_to self.user.uuid, status: "process"
  end

  def set_balance
    # foto_url = Cloudinary::Utils.cloudinary_url(self.foto.key, :width => 300, :height => 300, :crop => :scale)
    foto_url = Cloudinary::Utils.cloudinary_url(self.foto.key)
    botol_valid = Botol.validate(foto_url)
    harga_botol = 65 # Nanti disesuaikan sesuai botol yang masuk
    if botol_valid
      box = Box.find(self.box_id)
      mitra_amount = box.mitra_share * harga_botol / 100
      user_amount = box.user_share * harga_botol / 100
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
                                 diterima: false
    end
  end

  # def set_balance_old
  #   foto_url = Cloudinary::Utils.cloudinary_url(self.foto.key, :width => 300, :height => 300, :crop => :scale)

  #   if Botol.validate(foto_url)
  #     self.harga = harga_botol
  #     self.diterima = true
  #     self.save
  #     trx = Usertransaction.where(user_id: self.user_id).last
  #     description = "Reward Trx: " + self.id.to_s
  #     if trx
  #       balance = trx.balance
  #       trx = Usertransaction.create!(user_id: self.user_id, credit: self.user_amount, balance: balance + self.user_amount, description: description)
  #     else
  #       Usertransaction.create!(user_id: self.user_id, credit: self.user_amount, balance: self.user_amount, description: description)
  #     end

  #     trx = Mitratransaction.where(mitra_id: self.mitra_id).last
  #     if trx
  #       balance = trx.balance
  #       trx = Mitratransaction.create!(mitra_id: self.mitra_id, credit: self.mitra_amount, balance: balance + self.mitra_amount, description: description)
  #     else
  #       Mitratransaction.create!(mitra_id: self.mitra_id, credit: self.mitra_amount, balance: self.mitra_amount, description: description)
  #     end
  #     NotifyChannel.broadcast_to self.user.uuid,
  #       status: "complete",
  #       image: foto_url,
  #       diterima: true
  #   else
  #     NotifyChannel.broadcast_to self.user.uuid,
  #                                status: "complete",
  #                                image: foto_url,
  #                                diterima: false
  #   end
  # end
end
