# == Schema Information
#
# Table name: ppobs
#
#  id         :bigint           not null, primary key
#  amount     :string(255)
#  body       :text(65535)
#  status     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
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
