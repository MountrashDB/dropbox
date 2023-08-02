# == Schema Information
#
# Table name: order_details
#
#  id         :bigint           not null, primary key
#  harga      :float(24)
#  jenis      :string(255)
#  qty        :float(24)
#  satuan     :string(255)
#  sub_total  :float(24)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  order_id   :bigint           not null
#
# Indexes
#
#  index_order_details_on_order_id  (order_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#
class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :botol
end
