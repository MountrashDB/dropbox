# == Schema Information
#
# Table name: outlet_alamats
#
#  id         :bigint           not null, primary key
#  alamat     :string(255)
#  name       :string(255)
#  phone      :string(255)
#  pic        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  outlet_id  :bigint           not null
#
# Indexes
#
#  index_outlet_alamats_on_outlet_id  (outlet_id)
#
# Foreign Keys
#
#  fk_rails_...  (outlet_id => outlets.id)
#
require "test_helper"

class OutletAlamatTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end