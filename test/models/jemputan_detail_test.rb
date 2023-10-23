# == Schema Information
#
# Table name: jemputan_details
#
#  id             :bigint           not null, primary key
#  harga          :float(24)
#  qty            :integer
#  sub_total      :float(24)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  jemputan_id    :bigint           not null
#  tipe_sampah_id :bigint           not null
#
# Indexes
#
#  index_jemputan_details_on_jemputan_id     (jemputan_id)
#  index_jemputan_details_on_tipe_sampah_id  (tipe_sampah_id)
#
# Foreign Keys
#
#  fk_rails_...  (jemputan_id => jemputans.id)
#  fk_rails_...  (tipe_sampah_id => tipe_sampahs.id)
#
require "test_helper"

class JemputanDetailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
