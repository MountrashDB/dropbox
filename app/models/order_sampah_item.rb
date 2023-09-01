# == Schema Information
#
# Table name: order_sampah_items
#
#  id              :bigint           not null, primary key
#  qty             :float(24)
#  sub_total       :float(24)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  order_sampah_id :bigint           not null
#  tipe_sampah_id  :bigint           not null
#
# Indexes
#
#  index_order_sampah_items_on_order_sampah_id  (order_sampah_id)
#  index_order_sampah_items_on_tipe_sampah_id   (tipe_sampah_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_sampah_id => order_sampahs.id)
#  fk_rails_...  (tipe_sampah_id => tipe_sampahs.id)
#
class OrderSampahItem < ApplicationRecord
  belongs_to :ordersampah
  belongs_to :tipesampah
end