# == Schema Information
#
# Table name: bukti_pembayarans
#
#  id         :bigint           not null, primary key
#  keterangan :string(255)
#  nominal    :float(24)
#  status     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  admin_id   :bigint
#  mitra_id   :bigint           not null
#
# Indexes
#
#  index_bukti_pembayarans_on_admin_id  (admin_id)
#  index_bukti_pembayarans_on_mitra_id  (mitra_id)
#
# Foreign Keys
#
#  fk_rails_...  (admin_id => admins.id)
#  fk_rails_...  (mitra_id => mitras.id)
#
class BuktiPembayaran < ApplicationRecord
  include AASM
  belongs_to :mitra
  belongs_to :admin, optional: true
  has_one_attached :image, dependent: :destroy, service: :local  
  validates :image, presence: true

  aasm column: :status do
    state :requested, initial: true
    state :approved, :rejected

    event :approving, after_commit: :mitra_credit_balance do
      transitions from: :requested, to: :approved
    end

    event :rejecting do
      transitions from: :requested, to: :rejected
    end
  end

  def mitra_credit_balance
    mitra_id = self.mitra_id
    mitra.creditkan(self.nominal, 'Top Up Approved')
  end
end
