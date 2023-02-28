# == Schema Information
#
# Table name: districts
#
#  id          :bigint           not null, primary key
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  city_id     :bigint           not null
#  province_id :bigint           not null
#
# Indexes
#
#  index_districts_on_city_id      (city_id)
#  index_districts_on_province_id  (province_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (province_id => provinces.id)
#
require "test_helper"

class DistrictTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
