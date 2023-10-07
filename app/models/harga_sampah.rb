# == Schema Information
#
# Table name: harga_sampahs
#
#  id             :bigint           not null, primary key
#  harga_kg       :float(24)
#  harga_satuan   :float(24)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  banksampah_id  :bigint           not null
#  tipe_sampah_id :bigint           not null
#
# Indexes
#
#  index_harga_sampahs_on_banksampah_id   (banksampah_id)
#  index_harga_sampahs_on_tipe_sampah_id  (tipe_sampah_id)
#
# Foreign Keys
#
#  fk_rails_...  (banksampah_id => banksampahs.id)
#  fk_rails_...  (tipe_sampah_id => tipe_sampahs.id)
#
class HargaSampah < ApplicationRecord
  belongs_to :banksampah, optional: true
  belongs_to :tipe_sampah, optional: true
end
