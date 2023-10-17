# == Schema Information
#
# Table name: jam_jemputs
#
#  id         :bigint           not null, primary key
#  label      :string(255)
#  urut       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class JamJemput < ApplicationRecord
end
