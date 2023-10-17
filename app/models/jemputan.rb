# == Schema Information
#
# Table name: jemputans
#
#  id               :bigint           not null, primary key
#  catatan          :string(255)
#  fee              :float(24)
#  phone            :string(255)
#  status           :string(255)
#  sub_total        :float(24)
#  total            :float(24)
#  uuid             :string(255)
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
  belongs_to :user
  belongs_to :alamat_jemput
  belongs_to :jam_jemput
  before_create :set_uuid

  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  # aasm column: :status do
  #   state :requested, initial: true
  #   state :checked, :rejected, :paid

  #   event :checking do
  #     transitions from: :requested, to: :checked
  #   end

  #   event :jemput_sampah do
  #     transactions from: :checked, to: :jemput
  #   end

  #   event :rejecting do
  #     transactions from: :checked, to: :rejected
  #   end

  #   event :paying do
  #     transactions from: :jemput, to: :paid
  #   end
  # end
end
