# == Schema Information
#
# Table name: mitras
#
#  id              :bigint           not null, primary key
#  activation_code :string(255)
#  address         :string(255)
#  avatar          :string(255)
#  contact         :string(255)
#  dates           :datetime
#  email           :string(255)
#  name            :string(255)
#  password_digest :string(255)
#  phone           :string(255)
#  status          :integer
#  terms           :integer
#  uuid            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Mitra < ApplicationRecord
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
    validates :email, length: { in: 1..100 },  presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
    has_secure_password
    before_create :set_uuid

    def set_uuid
        self.uuid = SecureRandom.uuid
        self.activation_code = rand(10000..99999)
        self.status = 0    
    end
end
