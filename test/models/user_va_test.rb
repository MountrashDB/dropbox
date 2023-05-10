# == Schema Information
#
# Table name: user_vas
#
#  id         :bigint           not null, primary key
#  expired    :datetime
#  kodeBank   :string(255)
#  name       :string(255)
#  rekening   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_user_vas_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class UserVaTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
