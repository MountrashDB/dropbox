# == Schema Information
#
# Table name: sampahs
#
#  id             :bigint           not null, primary key
#  active         :boolean
#  code           :string(255)
#  description    :string(255)
#  harga_kg       :float(24)
#  harga_satuan   :float(24)
#  name           :string(255)
#  uuid           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  banksampah_id  :bigint           not null
#  tipe_sampah_id :bigint           not null
#
# Indexes
#
#  index_sampahs_on_banksampah_id   (banksampah_id)
#  index_sampahs_on_tipe_sampah_id  (tipe_sampah_id)
#
# Foreign Keys
#
#  fk_rails_...  (banksampah_id => banksampahs.id)
#  fk_rails_...  (tipe_sampah_id => tipe_sampahs.id)
#
class Sampah < ApplicationRecord
  belongs_to :tipe_sampah
  belongs_to :banksampah
  before_create :set_uuid

  validates :name, presence: true
  validates :code, uniqueness: true, presence: true
  validates :harga_satuan, presence: true
  validates :harga_kg, presence: true

  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
