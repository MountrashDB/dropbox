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
  
  def set_uuid
      self.uuid = SecureRandom.uuid
  end
end
