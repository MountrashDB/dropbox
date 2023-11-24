# == Schema Information
#
# Table name: outlets
#
#  id           :bigint           not null, primary key
#  active       :boolean
#  alamat       :string(255)
#  contact_name :string(255)
#  email        :string(255)
#  harga        :float(24)
#  mac          :string(255)
#  name         :string(255)
#  otp          :integer
#  phone        :string(255)
#  uuid         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  city_id      :bigint           not null
#  district_id  :bigint           not null
#  province_id  :bigint           not null
#
# Indexes
#
#  index_outlets_on_city_id      (city_id)
#  index_outlets_on_district_id  (district_id)
#  index_outlets_on_province_id  (province_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (district_id => districts.id)
#  fk_rails_...  (province_id => provinces.id)
#
class Outlet < ApplicationRecord
  belongs_to :city
  belongs_to :province
  belongs_to :district
end
