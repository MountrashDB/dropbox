# == Schema Information
#
# Table name: mountpays
#
#  id          :bigint           not null, primary key
#  balance     :float(24)
#  credit      :float(24)
#  debit       :float(24)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  mitra_id    :bigint
#  user_id     :bigint
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
require "test_helper"

class MountpayTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end