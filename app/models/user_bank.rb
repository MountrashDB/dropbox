# == Schema Information
#
# Table name: user_banks
#
#  id         :bigint           not null, primary key
#  is_valid   :boolean
#  kodeBank   :string(255)
#  nama       :string(255)
#  nama_bank  :string(255)
#  rekening   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_user_banks_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class UserBank < ApplicationRecord
  belongs_to :user
  validates :nama, presence: true
  validates :nama_bank, presence: true
  validates :rekening, presence: true
  validates :kodeBank, presence: true
end
