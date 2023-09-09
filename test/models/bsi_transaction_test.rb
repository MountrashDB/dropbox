# == Schema Information
#
# Table name: bsi_transactions
#
#  id            :bigint           not null, primary key
#  balance       :float(24)
#  credit        :float(24)
#  debit         :float(24)
#  description   :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  banksampah_id :bigint           not null
#
# Indexes
#
#  index_bsi_transactions_on_banksampah_id  (banksampah_id)
#
# Foreign Keys
#
#  fk_rails_...  (banksampah_id => banksampahs.id)
#
require "test_helper"

class BsiTransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
