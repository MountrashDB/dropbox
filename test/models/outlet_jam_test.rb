# == Schema Information
#
# Table name: outlet_jams
#
#  id         :bigint           not null, primary key
#  active     :boolean
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class OutletJamTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
