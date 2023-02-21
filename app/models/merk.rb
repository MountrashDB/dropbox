# == Schema Information
#
# Table name: merks
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  uuid       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Merk < ApplicationRecord
    before_create :set_uuid

    def set_uuid
        self.uuid = SecureRandom.uuid
    end
end
