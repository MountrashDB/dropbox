# == Schema Information
#
# Table name: ppobs
#
#  id           :bigint           not null, primary key
#  amount       :float(24)
#  body         :text(65535)
#  desc         :string(255)
#  ppob_type    :string(255)
#  profit       :float(24)
#  status       :string(255)
#  vendor_price :float(24)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  ref_id       :string(255)
#  tr_id        :integer
#  user_id      :bigint           not null
#
# Indexes
#
#  index_ppobs_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class PpobTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
