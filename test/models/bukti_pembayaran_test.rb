# == Schema Information
#
# Table name: bukti_pembayarans
#
#  id         :bigint           not null, primary key
#  keterangan :string(255)
#  nominal    :float(24)
#  status     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  admin_id   :bigint
#  mitra_id   :bigint           not null
#
# Indexes
#
#  index_bukti_pembayarans_on_admin_id  (admin_id)
#  index_bukti_pembayarans_on_mitra_id  (mitra_id)
#
# Foreign Keys
#
#  fk_rails_...  (admin_id => admins.id)
#  fk_rails_...  (mitra_id => mitras.id)
#
require "test_helper"

class BuktiPembayaranTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end