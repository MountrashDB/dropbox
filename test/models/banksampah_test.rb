# == Schema Information
#
# Table name: banksampahs
#
#  id                     :bigint           not null, primary key
#  activation_code        :string(255)
#  active                 :boolean
#  address                :string(255)
#  code                   :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  name                   :string(255)
#  phone                  :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  uuid                   :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  city_id                :bigint
#  district_id            :bigint
#  province_id            :bigint
#
# Indexes
#
#  index_banksampahs_on_city_id               (city_id)
#  index_banksampahs_on_district_id           (district_id)
#  index_banksampahs_on_email                 (email) UNIQUE
#  index_banksampahs_on_province_id           (province_id)
#  index_banksampahs_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (district_id => districts.id)
#  fk_rails_...  (province_id => provinces.id)
#
require "test_helper"

class BanksampahTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
