# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  active                 :boolean
#  active_code            :integer
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  name                   :string(255)
#  phone                  :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  username               :string(255)
#  uuid                   :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  has_secure_password
  validates :username, length: { in: 1..35 }, presence: true
  validates :phone, presence: true
  validates :email, length: { in: 1..100 },  presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  before_create :set_uuid

  def set_uuid
      self.uuid = SecureRandom.uuid
      self.active_code = rand(100000000..999999999)
  end
end
