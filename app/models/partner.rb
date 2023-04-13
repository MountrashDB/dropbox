# == Schema Information
#
# Table name: partners
#
#  id              :bigint           not null, primary key
#  alamat_kantor   :text(65535)
#  api_key         :string(255)
#  api_secret      :string(255)
#  approved        :boolean
#  email           :string(255)
#  handphone       :string(255)
#  nama            :string(255)
#  nama_usaha      :string(255)
#  password_digest :string(255)
#  uuid            :string(255)
#  verified        :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Partner < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :email, length: { in: 1..100 }, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :nama, length: { in: 5..100 }, presence: true
  validates :nama_usaha, length: { in: 5..100 }, presence: true
  validates :alamat_kantor, length: { in: 5..200 }, presence: true
  has_secure_password

  before_create :set_uuid

  def set_uuid
    self.uuid = SecureRandom.uuid
    self.api_key = SecureRandom.hex
    self.api_secret = SecureRandom.alphanumeric(100)
  end

  def self.get_header(headers)
    jwt = headers["Authorization"].split(" ").last
    begin
      decode = JWT.decode jwt, Rails.application.credentials.secret_key_base, true, { algorithm: Rails.application.credentials.token_algorithm }
      partner = Partner.find_by(uuid: decode[0]["uuid"])
    rescue JWT::ExpiredSignature
      false
    end
  end

  def self.get_jwt(jwt)
    decode = JWT.decode jwt, Rails.application.credentials.secret_key_base, true, { algorithm: Rails.application.credentials.token_algorithm }
    partner = Partner.find_by(uuid: decode[0]["uuid"])
  end

  def self.dashboard(partner_id)
    mitras = Mitra.where(partner_id: partner_id)
    users = User.where(partner_id: partner_id)
    transactions = Transaction.where(user: users)
    result = {
      mitra: {
        active: mitras.active.count,
        total: mitras.count,
      },
      user: {
        active: users.active.count,
        total: users.count,
      },
      transaction: {
        success: transactions.berhasil.count,
        total: transactions.count,
      },
    }
  end
end
