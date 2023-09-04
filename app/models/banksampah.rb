# == Schema Information
#
# Table name: banksampahs
#
#  id                     :bigint           not null, primary key
#  activation_code        :string(255)
#  active                 :boolean
#  address                :string(255)
#  code                   :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  latitude               :string(255)
#  longitude              :string(255)
#  name                   :string(255)
#  phone                  :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  uuid                   :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  city_id                :bigint
#  district_id            :bigint
#  province_id            :bigint
#
# Indexes
#
#  index_banksampahs_on_city_id               (city_id)
#  index_banksampahs_on_district_id           (district_id)
#  index_banksampahs_on_email                 (email) UNIQUE
#  index_banksampahs_on_province_id           (province_id)
#  index_banksampahs_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (district_id => districts.id)
#  fk_rails_...  (province_id => provinces.id)
#
class Banksampah < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :name, presence: true
  validates :email, length: { in: 1..100 }, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :phone, phone: { possible: true, allow_blank: true, types: [:voip, :mobile] }
  belongs_to :province, optional: true
  belongs_to :city, optional: true
  belongs_to :district, optional: true
  before_create :set_init
  after_create :send_email
  has_many :order_sampahs
  has_many :sampahs

  def set_init
    self.uuid = SecureRandom.uuid
    self.activation_code = SecureRandom.uuid
  end

  def self.get_banksampah(headers)
    token = headers["Authorization"].split(" ").last
    begin
      decode = JWT.decode token, ENV["secret_key_base"], true, { algorithm: ENV["token_algorithm"] }
      @current_banksampah = Banksampah.find_by(uuid: decode[0]["banksampah_uuid"])
    rescue JWT::ExpiredSignature
      false
    end
  end

  def send_email
    BanksampahMailer.welcome_email(self).deliver_now!
  end
end
