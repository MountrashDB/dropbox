# == Schema Information
#
# Table name: order_sampahs
#
#  id            :bigint           not null, primary key
#  fee           :float(24)
#  status        :string(255)
#  sub_total     :float(24)
#  total         :float(24)
#  uuid          :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  banksampah_id :bigint           not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_order_sampahs_on_banksampah_id  (banksampah_id)
#  index_order_sampahs_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (banksampah_id => banksampahs.id)
#  fk_rails_...  (user_id => users.id)
#
class OrderSampah < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :banksampah
  has_many :order_details, dependent: :destroy
  has_many :sampah_details, dependent: :destroy
  before_create :set_uuid

  aasm column: :status do
    state :requested, initial: true
    state :accepted, :paid, :rejected

    event :diterima do
      transitions from: :requested, to: :accepted
    end

    event :paidkan do
      transitions from: :accepted, to: :paid
    end

    event :ditolak do
      transitions from: :requested, to: :rejected
    end
  end

  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
