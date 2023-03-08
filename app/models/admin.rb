# == Schema Information
#
# Table name: admins
#
#  id                     :bigint           not null, primary key
#  active                 :boolean
#  authentication_token   :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  first_name             :string(255)      default(""), not null
#  last_name              :string(255)      default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  uuid                   :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_admins_on_email                 (email) UNIQUE
#  index_admins_on_reset_password_token  (reset_password_token) UNIQUE
#
class Admin < ApplicationRecord
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :first_name, length: { in: 1..35 }, allow_blank: true
  validates :last_name, length: { in: 1..35 }, allow_blank: true
  validates :email, length: { in: 1..100 },  presence: true, uniqueness: true, format: { with: EMAIL_REGEX }
  validates :password, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :image, dependent: :destroy, service: :cloudinary 
  before_create :set_uuid

  def set_uuid
      self.uuid = SecureRandom.uuid
  end
         
  def self.get_admin(headers)    
    token = headers['Authorization'].split(' ').last        
    begin            
      decode = JWT.decode token, Rails.application.credentials.secret_key_base, true, { algorithm: Rails.application.credentials.token_algorithm }
      admin = Admin.find_by(uuid: decode[0]["admin_uuid"])
    rescue JWT::ExpiredSignature
      false
    end    
  end
      
end
