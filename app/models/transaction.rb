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
    ActionCable.server.broadcast("NotifyChannel_#{self.user.uuid}", {
      status: "process",
      message: "Memvalidasi...",
      point: self.user_amount,
      image: self.foto.url,
    })
    # NotifyChannel.broadcast_to self.user.uuid,
    #                            status: "process",
    #                            message: "Memvalidasi...",
    #                            point: self.user_amount,
    #                            image: self.foto.url
  end

  def set_balance
    BotolDetectionJob.perform_at(2.seconds.from_now, self.id)
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
        image: self.foto.url,
        point: user_amount,
        diterima: true,
        balance: user.usertransactions.balance,
        message: "Congratulations you get a point of",
      })
    end
  end
end
