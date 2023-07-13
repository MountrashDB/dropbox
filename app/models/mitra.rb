# == Schema Information
#
# Table name: mitras
#
#  id                     :bigint           not null, primary key
#  activation_code        :string(255)
#  address                :string(255)
#  avatar                 :string(255)
#  contact                :string(255)
#  dates                  :datetime
#  email                  :string(255)
#  encrypted_password     :string(255)
#  name                   :string(255)
#  phone                  :string(255)
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  status                 :integer
#  terms                  :integer
#  uuid                   :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  partner_id             :integer
#

class Mitra < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :name, presence: true
  validates :email, length: { in: 1..100 }, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  before_create :set_uuid
  has_many :kyc, dependent: :destroy
  has_many :box, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :mitratransactions, dependent: :destroy
  has_one :mitra_bank, dependent: :destroy

  belongs_to :partner, optional: true
  has_one_attached :image, dependent: :destroy, service: :cloudinary
  scope :active, -> { where(status: 1) }

  @@url = Rails.application.credentials.linkqu[:url]
  @@username = Rails.application.credentials.linkqu[:username]
  @@pin = Rails.application.credentials.linkqu[:pin]

  def set_uuid
    self.uuid = SecureRandom.uuid
    self.activation_code = rand(100000000..999999999)
    self.status = 0
  end

  def self.get_mitra(headers)
    token = headers["Authorization"].split(" ").last
    begin
      decode = JWT.decode token, Rails.application.credentials.secret_key_base, true, { algorithm: Rails.application.credentials.token_algorithm }
      @current_mitra = Mitra.find_by(uuid: decode[0]["mitra_uuid"])
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
        "partner_reff": "Validasi",
        "sendername": "Dropbox",
        "category": "99",
        "customeridentity": "Mitra",
      }

      request.body = JSON.dump(data)
      response = https.request(request)
      result = JSON.parse(response.read_body)
      if result["accountname"] == nama_rekening
        true
      else
        false
      end
    rescue
      false
    end
  end

  def creditkan(amount, description)
    balance = self.mitratransactions.balance
    Mitratransaction.create!(
      mitra_id: self.id,
      credit: amount,
      debit: 0,
      balance: balance + amount,
      description: description,
    )
  end

  def debitkan(amount, description)
    balance = self.mitratransactions.balance
    Mitratransaction.create!(
      mitra_id: self.id,
      credit: 0,
      debit: amount,
      balance: balance - amount,
      description: description,
    )
  end
end
