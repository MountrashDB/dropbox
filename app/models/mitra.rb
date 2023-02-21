# == Schema Information
#
# Table name: mitras
#
#  id         :bigint           not null, primary key
#  address    :string(255)
#  contact    :string(255)
#  email      :string(255)
#  name       :string(255)
#  phone      :string(255)
#  uuid       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Mitra < ApplicationRecord
    before_create :set_uuid

    def set_uuid
        self.uuid = SecureRandom.uuid
    end
end
