# == Schema Information
#
# Table name: histories
#
#  id          :bigint           not null, primary key
#  amount      :float(24)
#  description :string(255)
#  title       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_histories_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class HistoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
