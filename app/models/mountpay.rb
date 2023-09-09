# == Schema Information
#
# Table name: mountpays
#
#  id            :bigint           not null, primary key
#  balance       :float(24)
#  credit        :float(24)
#  debit         :float(24)
#  description   :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  banksampah_id :integer
#  mitra_id      :bigint
#  user_id       :bigint
#
# Indexes
#
#  index_mountpays_on_mitra_id  (mitra_id)
#  index_mountpays_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (mitra_id => mitras.id)
#  fk_rails_...  (user_id => users.id)
#
class Mountpay < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :mitra, optional: true
  belongs_to :banksampah, optional: true
  scope :balance, -> { pluck(:balance).last || 0 }
end
