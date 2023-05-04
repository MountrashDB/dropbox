# == Schema Information
#
# Table name: withdrawls
#
#  id                 :bigint           not null, primary key
#  amount             :float(24)
#  kodeBank           :string(255)
#  nama               :string(255)
#  rekening           :string(255)
#  status             :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :bigint           not null
#  usertransaction_id :bigint           not null
#
# Indexes
#
#  index_withdrawls_on_user_id             (user_id)
#  index_withdrawls_on_usertransaction_id  (usertransaction_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (usertransaction_id => usertransactions.id)
#
require "test_helper"

class WithdrawlTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end