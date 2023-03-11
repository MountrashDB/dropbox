# == Schema Information
#
# Table name: mitratransactions
#
#  id          :bigint           not null, primary key
#  balance     :float(24)        default(0.0)
#  credit      :float(24)        default(0.0)
#  debit       :float(24)        default(0.0)
#  description :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  mitra_id    :bigint           not null
#
# Indexes
#
#  index_mitratransactions_on_mitra_id  (mitra_id)
#
# Foreign Keys
#
#  fk_rails_...  (mitra_id => mitras.id)
#
require "test_helper"

class MitratransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
