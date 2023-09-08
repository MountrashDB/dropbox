# == Schema Information
#
# Table name: kycs
#
#  id             :bigint           not null, primary key
#  agama          :string(255)
#  desa           :string(255)
#  nama           :string(255)
#  no_ktp         :string(255)
#  pekerjaan      :string(255)
#  rt             :string(255)
#  rw             :string(255)
#  status         :integer
#  tempat_tinggal :string(255)
#  tgl_lahir      :date
#  uuid           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  city_id        :bigint           not null
#  district_id    :bigint           not null
#  mitra_id       :bigint           not null
#  province_id    :bigint           not null
#
# Indexes
#
#  index_kycs_on_city_id      (city_id)
#  index_kycs_on_district_id  (district_id)
#  index_kycs_on_mitra_id     (mitra_id)
#  index_kycs_on_province_id  (province_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (district_id => districts.id)
#  fk_rails_...  (mitra_id => mitras.id)
#  fk_rails_...  (province_id => provinces.id)
#
class Kyc < ApplicationRecord
  belongs_to :province
  belongs_to :city
  belongs_to :district
  belongs_to :mitra
  has_one_attached :ktp_image, dependent: :destroy

  validates :ktp_image, :nama, :no_ktp, :tempat_tinggal, :tgl_lahir, :province_id, :city_id, :district_id, :mitra_id, presence: true

  before_create :set_value

  def set_value
    self.uuid = SecureRandom.uuid
    self.status = 0 #Waiting approve, 1 = Approved, 2 = Rejected
  end
end
