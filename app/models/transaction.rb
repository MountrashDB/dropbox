# == Schema Information
#
# Table name: transactions
#
#  id           :bigint           not null, primary key
#  diterima     :boolean
#  gambar       :string(255)
#  harga        :float(24)
#  mitra_amount :float(24)
#  phash        :string(255)
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
  has_one_attached :foto, dependent: :destroy, service: :local
  mount_uploader :gambar, FotoUploader
  before_create :set_uuid
  belongs_to :mitra
  belongs_to :user
  belongs_to :box
  belongs_to :botol, optional: true

  after_create :set_balance, :send_notify
  # after_create :send_notify
  before_create :check_duplicate_gambar
  scope :berhasil, -> { where(diterima: true) }
  after_update :reverse_balance
  before_destroy :reverse_user_balance
  after_commit :remove_gambar!, on: :destroy

  def check_duplicate_gambar
    if trx = Transaction.where(box_id: self.box_id)
      if trx = trx.last
        last_phash = trx.phash.to_i        
        jarak = Phashion.hamming_distance self.phash.to_i, last_phash      
        if jarak < 10                
          raise ActiveRecord::Rollback, "Duplicate image"
        end
      end
    end
  end
  
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
    trx = Transaction.find(self.id)    
    ActionCable.server.broadcast("NotifyChannel_#{self.user.uuid}", {
      status: "process",
      message: "Memvalidasi...",
      point: self.user_amount,
      image: trx.gambar.url,
    })

    # @current_user.history_tambahkan(harga_jual, "PPOB", ppob.desc)
    # NotifyChannel.broadcast_to self.user.uuid,
    #                            status: "process",
    #                            message: "Memvalidasi...",
    #                            point: self.user_amount,
    #                            image: self.foto.url
  end

  def set_balance
    # BotolDetectionJob.perform_at(2.seconds.from_now, self.id)
    # Karena tdk ada pengecekan transaction update otomatis
    transaction = Transaction.find(self.id)
    transaction.diterima = true
    transaction.save
    user = User.find(self.user.id)
    ActionCable.server.broadcast("NotifyChannel_#{transaction.user.uuid}", {
        status: "complete",
        image: transaction.gambar_url,
        point: transaction.user_amount,
        diterima: true,
        balance: user.usertransactions.balance,
        message: "Congratulations you get a point of",
    })
    transaction.user.history_tambahkan(transaction.user_amount, "Botol", "Diterima")
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
    if self.diterima
      # Investor.debitkan(investor_amount, "Trx rejected")
      # User.find(self.user_id).debitkan(self.user_amount, "Trx rejected")
      # Mitra.find(self.mitra_id).debitkan(self.mitra_amount, "Trx rejected")
      # Transaction.find(self.id).destroy
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

      ActionCable.server.broadcast("NotifyChannel_#{self.user.uuid}", {
        status: "complete",
        image: self.gambar.url,
        point: user_amount,
        diterima: true,
        balance: user.usertransactions.balance,
        message: "Congratulations you get a point of",
      })
    end
  end

  def reverse_user_balance
    if self.diterima # Reverse balance if it was accepted
      # box = Box.find(self.box_id)
      # mitra_amount = box.mitra_share * self.harga / 100
      # user_amount = box.user_share * self.harga / 100
      investor_amount = self.harga - self.user_amount - self.mitra_amount
      Investor.debitkan(investor_amount, "Trx destroyed")
      User.find(self.user_id).debitkan(self.user_amount, "Trx destroyed")
      Mitra.find(self.mitra_id).debitkan(self.mitra_amount, "Trx destroyed")
    end
  end
end
