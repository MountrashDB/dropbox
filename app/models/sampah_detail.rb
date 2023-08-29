# == Schema Information
#
# Table name: sampah_details
#
#  id              :bigint           not null, primary key
#  harga           :float(24)
#  qty             :float(24)
#  satuan          :string(255)
#  sub_total       :float(24)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  order_sampah_id :bigint           not null
#  sampah_id       :bigint           not null
#
# Indexes
#
#  index_sampah_details_on_order_sampah_id  (order_sampah_id)
#  index_sampah_details_on_sampah_id        (sampah_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_sampah_id => order_sampahs.id)
#  fk_rails_...  (sampah_id => sampahs.id)
#
class SampahDetail < ApplicationRecord
  belongs_to :order_sampah
  belongs_to :sampah
end
