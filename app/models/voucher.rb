# == Schema Information
#
# Table name: vouchers
#
#  id         :bigint           not null, primary key
#  avai_end   :date
#  avai_start :date
#  code       :integer
#  days       :integer
#  expired    :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  outlet_id  :bigint           not null
#
# Indexes
#
#  index_vouchers_on_outlet_id  (outlet_id)
#
# Foreign Keys
#
#  fk_rails_...  (outlet_id => outlets.id)
#
class Voucher < ApplicationRecord
  include AASM

  belongs_to :outlet
  validates :code, uniqueness: true
  before_create :set_code
  
  def set_code
    self.code = rand(100000..999999)
  end

  aasm column: :status do
    state :created, initial: true
    state :paid, :expired

    event :paying do
      transitions from: :created, to: :paid
    end

    event :expiring do
      transitions from: :paid, to: :expired
    end
  end
end
