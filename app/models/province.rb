# == Schema Information
#
# Table name: provinces
#
#  id         :bigint           not null, primary key
#  displays   :integer
#  kode       :string(255)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Province < ApplicationRecord
end
