# == Schema Information
#
# Table name: mitra_vas
#
#  id         :bigint           not null, primary key
#  active     :boolean
#  bank_name  :string(255)
#  expired    :datetime
#  fee        :float(24)
#  kodeBank   :string(255)
#  name       :string(255)
#  rekening   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  mitra_id   :bigint           not null
#
# Indexes
#
#  index_mitra_vas_on_mitra_id  (mitra_id)
#
# Foreign Keys
#
#  fk_rails_...  (mitra_id => mitras.id)
#
class MitraVa < ApplicationRecord
end
