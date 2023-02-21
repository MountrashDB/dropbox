# == Schema Information
#
# Table name: merks
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  uuid       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class MerkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
