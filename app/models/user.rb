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
#  google_id              :string(45)
#  partner_id             :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require "net/http"
require "openssl"

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  # has_secure_password
  validates :username, length: { in: 1..35 }, presence: true
  # validates :phone, presence: true
  validates :email, length: { in: 1..100 }, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  scope :active, -> { where(active: true) }

  has_many :transactions, dependent: :destroy
  has_many :usertransactions, dependent: :destroy
  has_many :mountpay, dependent: :destroy
  has_one :user_bank, dependent: :destroy
  before_create :set_uuid

  @@url = Rails.application.credentials.linkqu[:url]
  @@username = Rails.application.credentials.linkqu[:username]
  @@pin = Rails.application.credentials.linkqu[:pin]

  def set_uuid
    self.uuid = SecureRandom.uuid
    self.active_code = rand(100000000..999999999)
  end

  def self.get_user(headers)
    token = headers["Authorization"].split(" ").last
    begin
      decode = JWT.decode token, Rails.application.credentials.secret_key_base, true, { algorithm: Rails.application.credentials.token_algorithm }
      @current_user = User.find_by(uuid: decode[0]["user_uuid"])
    rescue JWT::ExpiredSignature
      false
    end
  end

  def self.validate_bank(bankcode, rekening, nama_rekening)
    begin
      url = URI.parse(@@url + "/linkqu-partner/transaction/withdraw/inquiry")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request["client-id"] = Rails.application.credentials.linkqu[:client_id]
      request["client-secret"] = Rails.application.credentials.linkqu[:client_secret]
      data = {
        "username": @@username,
        "pin": @@pin,
        "bankcode": bankcode,
        "amount": 10000, #Just for validation
        "accountnumber": rekening,
        "partner_reff": "validate mitra",
        "sendername": "Dropbox",
        "category": "99",
        "customeridentity": "User",
      }

      request.body = JSON.dump(data)
      response = https.request(request)
      result = JSON.parse(response.read_body)
      true
      # if result["accountname"] == nama_rekening
      #   true
      # else
      #   false
      # end
    rescue
      false
    end
  end

  def creditkan(amount, description)
    balance = self.usertransactions.balance
    Usertransaction.create!(
      user_id: self.id,
      credit: amount,
      debit: 0,
      balance: balance + amount,
      description: description,
    )
  end

  def debitkan(amount, description)
    balance = self.usertransactions.balance
    Usertransaction.create!(
      user_id: self.id,
      credit: 0,
      debit: amount,
      balance: balance - amount,
      description: description,
    )
  end

  def self.create_va(bankcode, nama_rekening)
    begin
      url = URI.parse(@@url + "/linkqu-partner/transaction/create/vadedicated/add")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request["client-id"] = Rails.application.credentials.linkqu[:client_id]
      request["client-secret"] = Rails.application.credentials.linkqu[:client_secret]
      data = {
        "username": @@username,
        "pin": @@pin,
        "bankcode": bankcode,
        "customer_id": "user|1",
        "customer_name": nama_rekening,
        "customer_phone": "08129959717",
        "customer_email": "test@dropbox.com",
      }

      request.body = JSON.dump(data)
      response = https.request(request)
      result = JSON.parse(response.read_body)
    rescue
      false
    end
  end

  def mountpay_creditkan(amount, description)
    balance = self.mountpay.balance
    Mountpay.create!(
      user_id: self.id,
      credit: amount,
      debit: 0,
      balance: balance + amount,
      description: description,
    )
  end

  def mountpay_debitkan(amount, description)
    balance = self.mountpay.balance
    Mountpay.create!(
      user_id: self.id,
      credit: 0,
      debit: amount,
      balance: balance - amount,
      description: description,
    )
  end
end
