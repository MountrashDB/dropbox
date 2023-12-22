# == Schema Information
#
# Table name: vouchers
#
#  id         :bigint           not null, primary key
#  avai_end   :date
#  avai_start :date
#  code       :integer
#  days       :integer
#  status     :string(255)
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
require "test_helper"

class VoucherTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
