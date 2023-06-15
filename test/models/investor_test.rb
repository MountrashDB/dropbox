# == Schema Information
#
# Table name: investors
#
#  id          :bigint           not null, primary key
#  balance     :float(24)
#  credit      :float(24)
#  debit       :float(24)
#  description :string(255)
#  status      :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "test_helper"

class InvestorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
