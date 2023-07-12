# == Schema Information
#
# Table name: boxes
#
#  id            :bigint           not null, primary key
#  botol_total   :integer
#  cycles        :string(255)
#  dates         :datetime
#  jenis         :string(255)
#  latitude      :string(255)
#  longitude     :string(255)
#  max           :integer
#  mitra_info    :string(255)
#  mitra_share   :float(24)
#  nama          :string(255)
#  price_kg      :float(24)
#  price_pcs     :float(24)
#  qr_code       :string(255)
#  qty           :float(24)
#  revenue       :float(24)
#  type_progress :string(255)
#  user_share    :float(24)
#  uuid          :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  admin_id      :integer
#  mitra_id      :integer
#  user_id       :integer
#
require "test_helper"

class BoxTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
