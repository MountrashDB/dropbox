# == Schema Information
#
# Table name: order_sampahs
#
#  id            :bigint           not null, primary key
#  fee           :float(24)
#  status        :string(255)
#  sub_total     :float(24)
#  total         :float(24)
#  uuid          :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  banksampah_id :bigint           not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_order_sampahs_on_banksampah_id  (banksampah_id)
#  index_order_sampahs_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (banksampah_id => banksampahs.id)
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class OrderSampahTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end