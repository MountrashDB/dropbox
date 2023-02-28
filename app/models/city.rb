# == Schema Information
#
# Table name: cities
#
#  id          :bigint           not null, primary key
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  province_id :bigint           not null
#
# Indexes
#
#  index_cities_on_province_id  (province_id)
#
# Foreign Keys
#
#  fk_rails_...  (province_id => provinces.id)
#
class City < ApplicationRecord
  belongs_to :province
end
