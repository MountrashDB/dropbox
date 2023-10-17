# == Schema Information
#
# Table name: alamat_jemputs
#
#  id         :bigint           not null, primary key
#  alamat     :string(255)
#  catatan    :string(255)
#  kodepos    :string(255)
#  latitude   :string(255)
#  longitude  :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_alamat_jemputs_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class AlamatJemputTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
