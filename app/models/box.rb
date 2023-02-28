# == Schema Information
#
# Table name: boxes
#
#  id         :bigint           not null, primary key
#  lang       :string(255)
#  lat        :string(255)
#  max        :integer
#  qr_code    :string(255)
#  uuid       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Box < ApplicationRecord
    before_create :set_uuid

    def set_uuid
        self.uuid = SecureRandom.uuid
    end
end
