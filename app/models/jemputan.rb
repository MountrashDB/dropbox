# == Schema Information
#
# Table name: jemputans
#
#  id               :bigint           not null, primary key
#  berat            :float(24)
#  catatan          :string(255)
#  fee              :float(24)
#  gambar           :string(255)
#  phone            :string(255)
#  status           :string(255)
#  sub_total        :float(24)
#  tanggal          :date
#  total            :float(24)
#  uuid             :string(255)
#  voucher          :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  alamat_jemput_id :bigint           not null
#  jam_jemput_id    :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_jemputans_on_alamat_jemput_id  (alamat_jemput_id)
#  index_jemputans_on_jam_jemput_id     (jam_jemput_id)
#  index_jemputans_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (alamat_jemput_id => alamat_jemputs.id)
#  fk_rails_...  (jam_jemput_id => jam_jemputs.id)
#  fk_rails_...  (user_id => users.id)
#
class Jemputan < ApplicationRecord
  include AASM
  mount_uploader :gambar, JemputanUploader

  belongs_to :user
  belongs_to :alamat_jemput
  belongs_to :jam_jemput
  before_create :set_uuid
  validates :voucher, presence: true
  validates :tanggal, presence: true

  has_many :jemputan_details, dependent: :destroy
  has_many :jemputan_tipe_sampahs, dependent: :destroy

  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  aasm column: :status do
    state :created, initial: true
    state :requested, :cancelled, :checked, :jemput, :rejected, :complete

    event :sending do
      transitions from: :created, to: :requested
    end

    event :cancelling do
      transitions from: [:requested, :created], to: :cancelled
    end

    event :checking do
      transitions from: :requested, to: :checked
    end

    event :jemput_sampah do
      transitions from: :checked, to: :jemput
    end

    event :rejecting do
      transitions from: :checked, to: :rejected
    end

    event :complete do
      transitions from: :jemput, to: :complete
    end
  end
end
