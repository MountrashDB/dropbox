# == Schema Information
#
# Table name: jemputan_tipe_sampahs
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  jemputan_id    :bigint           not null
#  tipe_sampah_id :bigint           not null
#
# Indexes
#
#  index_jemputan_tipe_sampahs_on_jemputan_id     (jemputan_id)
#  index_jemputan_tipe_sampahs_on_tipe_sampah_id  (tipe_sampah_id)
#
# Foreign Keys
#
#  fk_rails_...  (jemputan_id => jemputans.id)
#  fk_rails_...  (tipe_sampah_id => tipe_sampahs.id)
#
class JemputanTipeSampah < ApplicationRecord
  belongs_to :jemputan
  belongs_to :tipe_sampah
end
