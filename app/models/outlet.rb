# == Schema Information
#
# Table name: outlets
#
#  id                     :bigint           not null, primary key
#  active                 :boolean
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  name                   :string(255)
#  phone                  :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  uuid                   :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_outlets_on_email                 (email) UNIQUE
#  index_outlets_on_reset_password_token  (reset_password_token) UNIQUE
#
class Outlet < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :voucher, dependent: :destroy
  has_many :outlet_alamats, dependent: :destroy
  before_create :set_uuid

  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  def self.get_outlet(headers)
    token = headers["Authorization"].split(" ").last
    begin
      decode = JWT.decode token, ENV["secret_key_base"], true, { algorithm: ENV["token_algorithm"] }
      @current_outlet = Outlet.find_by(uuid: decode[0]["outlet_uuid"], active: true)
    rescue JWT::ExpiredSignature
      false
    end
  end  
end
