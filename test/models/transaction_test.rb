# == Schema Information
#
# Table name: transactions
#
#  id           :bigint           not null, primary key
#  diterima     :boolean
#  harga        :float(24)
#  mitra_amount :float(24)
#  status       :string(255)      default("in")
#  user_amount  :float(24)
#  uuid         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  botol_id     :integer
#  box_id       :integer
#  mitra_id     :integer
#  user_id      :integer
#
require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
