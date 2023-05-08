# == Schema Information
#
# Table name: mitra_banks
#
#  id         :bigint           not null, primary key
#  is_valid   :boolean
#  kodeBank   :string(255)
#  nama       :string(255)
#  nama_bank  :string(255)
#  rekening   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  mitra_id   :bigint           not null
#
# Indexes
#
#  index_mitra_banks_on_mitra_id  (mitra_id)
#
# Foreign Keys
#
#  fk_rails_...  (mitra_id => mitras.id)
#
class MitraBank < ApplicationRecord
  belongs_to :mitra
end
