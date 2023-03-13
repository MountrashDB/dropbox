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
  has_one_attached :foto, dependent: :destroy, service: :cloudinary
  before_create :set_uuid
  belongs_to :mitra
  belongs_to :user
  belongs_to :box

  after_create :set_balance
  before_create :send_notify
  
  def set_uuid
      self.uuid = SecureRandom.uuid
  end

  def send_notify
    NotifyChannel.broadcast_to self.user.uuid, status: "process"
  end

  def set_balance    
    trx = Usertransaction.where(user_id: self.user_id).last    
    description = "Reward Trx: " + self.id.to_s
    if trx
      balance = trx.balance
      trx = Usertransaction.create!(user_id: self.user_id, credit: self.user_amount, balance: balance+self.user_amount, description: description)
    else
      Usertransaction.create!(user_id: self.user_id, credit: self.user_amount, balance: self.user_amount, description: description)
    end

    trx = Mitratransaction.where(mitra_id: self.mitra_id).last    
    if trx
      balance = trx.balance
      trx = Mitratransaction.create!(mitra_id: self.mitra_id, credit: self.mitra_amount, balance: balance+self.mitra_amount, description: description)
    else
      Mitratransaction.create!(mitra_id: self.mitra_id, credit: self.mitra_amount, balance: self.mitra_amount, description: description)
    end    
    NotifyChannel.broadcast_to self.user.uuid, 
      status: "complete", 
      image: self.foto.url, 
      diterima: true
  end
end
