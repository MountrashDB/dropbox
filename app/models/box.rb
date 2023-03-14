# == Schema Information
#
# Table name: boxes
#
#  id            :bigint           not null, primary key
#  cycles        :string(255)
#  dates         :datetime
#  jenis         :string(255)
#  latitude      :string(255)
#  longitude     :string(255)
#  max           :integer
#  mitra_info    :string(255)
#  mitra_share   :float(24)
#  nama          :string(255)
#  qr_code       :string(255)
#  qty           :float(24)
#  revenue       :float(24)
#  type_progress :string(255)
#  user_share    :float(24)
#  uuid          :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  admin_id      :integer
#  mitra_id      :integer
#  user_id       :integer
#
class Box < ApplicationRecord
    validates :uuid, uniqueness: true
    validates :nama, presence: true
    validates :cycles, presence: true
    validates :jenis, presence: true
    validates :cycles, presence: true
    validates :revenue, presence: true
    validates :user_share, presence: true
    validates :mitra_share, presence: true
    belongs_to :mitra
    belongs_to :admin
    belongs_to :user, optional: true
    before_create :set_uuid
    scope :current_mitra, -> { where(mitra_id: @current_mitra.id) }

    def set_uuid
        self.uuid = SecureRandom.uuid
        self.qr_code = self.uuid
        self.type_progress = "ongoing"        
    end
end
