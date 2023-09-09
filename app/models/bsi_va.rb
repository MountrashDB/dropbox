# == Schema Information
#
# Table name: bsi_vas
#
#  id            :bigint           not null, primary key
#  active        :boolean
#  bank_name     :string(255)
#  expired       :datetime
#  fee           :float(24)
#  kodeBank      :string(255)
#  name          :string(255)
#  rekening      :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  banksampah_id :bigint           not null
#
# Indexes
#
#  index_bsi_vas_on_banksampah_id  (banksampah_id)
#
# Foreign Keys
#
#  fk_rails_...  (banksampah_id => banksampahs.id)
#
class BsiVa < ApplicationRecord
  belongs_to :banksampah
end
