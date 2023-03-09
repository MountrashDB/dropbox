# == Schema Information
#
# Table name: botol_hargas
#
#  id         :bigint           not null, primary key
#  harga      :float(24)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  botol_id   :bigint           not null
#  box_id     :bigint           not null
#
# Indexes
#
#  index_botol_hargas_on_botol_id  (botol_id)
#  index_botol_hargas_on_box_id    (box_id)
#
# Foreign Keys
#
#  fk_rails_...  (botol_id => botols.id)
#  fk_rails_...  (box_id => boxes.id)
#
require "test_helper"

class BotolHargaTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
