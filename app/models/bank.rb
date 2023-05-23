# == Schema Information
#
# Table name: banks
#
#  id         :bigint           not null, primary key
#  is_active  :boolean
#  kode_bank  :string(255)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Bank < ApplicationRecord
end
