# == Schema Information
#
# Table name: ppobs
#
#  id           :bigint           not null, primary key
#  amount       :float(24)
#  body         :text(65535)
#  desc         :string(255)
#  ppob_type    :string(255)
#  profit       :float(24)
#  status       :string(255)
#  vendor_price :float(24)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  ref_id       :string(255)
#  tr_id        :integer
#  user_id      :bigint           not null
#
# Indexes
#
#  index_ppobs_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Ppob < ApplicationRecord
  include AASM

  # Production
  @@prepaid_url = Rails.application.credentials.iak[:prepaid]
  @@username = Rails.application.credentials.iak[:username]
  @@api_key = Rails.application.credentials.iak[:api_key]
  @@sign = Digest::MD5.hexdigest @@username + @@api_key
  @@sign_prepaid = Digest::MD5.hexdigest @@username + @@api_key + "pl"
  @@postpaid_url = Rails.application.credentials.iak[:postpaid]

  # Development
  # @@prepaid_url = "https://prepaid.iak.dev"
  # @@postpaid_url = "https://testpostpaid.mobilepulsa.net"
  # @@username = Rails.application.credentials.iak[:username]
  # @@api_key = "86061ea4b7c25e81"
  # @@sign = Digest::MD5.hexdigest @@username + @@api_key
  # @@sign_prepaid = Digest::MD5.hexdigest @@username + @@api_key + "pl"

  @@profit = Rails.application.credentials.iak[:profit]

  belongs_to :user
  # after_create :debit_mountpay

  aasm column: :status do
    state :process, initial: true
    state :success, :failed

    event :successkan do
      transitions from: :process, to: :success
    end

    event :failedkan, after_commit: :reverse_balance do
      transitions from: :process, to: :failed
    end
  end

  @@retry_count = 0

  def self.pricelist(tipe, operator, product_code = "")
    cache_name = "price-#{tipe}-#{operator}-#{product_code}-v1"
    daftar_harga = Rails.cache.fetch(cache_name, expires_in: 24.hours) do
      if tipe && operator
        begin
          conn = Faraday.new(
            url: @@prepaid_url,
            headers: { "Content-Type" => "application/json" },
            request: { timeout: 3 },
          )

          response = conn.post("/api/pricelist/#{tipe}/#{operator}") do |req|
            req.body = {
              status: "active",
              username: @@username,
              sign: @@sign_prepaid,
            }.to_json
          end
          result = JSON.parse(response.body)
          price_list = result["data"]["pricelist"]
          if product_code != ""
            result = price_list.select { |hash| hash["product_code"] == product_code }
            result.first["product_price"]
          else
            price_list
          end
        rescue => e
          if @@retry_count < 3
            @@retry_count += 1
            retry
          else
            puts "=== ERROR ==="
            puts e.message
            # Handle the failure case
          end
          nil
        end
      end
    end
    if !daftar_harga
      Rails.cache.delete(cache_name)
    end
    daftar_harga
  end

  def self.prepaid_buy(user, params_prepaid)
    if params_prepaid[:type] && params_prepaid[:operator]
      conn = Faraday.new(
        url: @@prepaid_url,
        headers: { "Content-Type" => "application/json" },
        request: { timeout: 3 },
      )
      ref_id = "user-#{user.uuid}-prepaid-#{Time.now.to_i}"
      sign = Digest::MD5.hexdigest @@username + @@api_key + ref_id
      body = {
        username: @@username,
        ref_id: ref_id,
        sign: sign,
      }
      response = conn.post("/api/top-up") do |req|
        req.body = body.merge(params_prepaid).to_json
      end
      response.body
    else
      nil
    end
  end

  def self.prepaid_status(ref_id)
    if ref_id
      begin
        conn = Faraday.new(
          url: @@prepaid_url,
          headers: { "Content-Type" => "application/json" },
          request: { timeout: 3 },
        )
        sign = Digest::MD5.hexdigest @@username + @@api_key + ref_id
        body = {
          username: @@username,
          ref_id: ref_id,
          sign: sign,
        }
        response = conn.post("/api/check-status") do |req|
          req.body = body.to_json
        end
        response.body
      rescue => e
        if @@retry_count < 3
          @@retry_count += 1
          retry
        else
          puts "=== ERROR ==="
          puts e.message
          # Handle the failure case
        end
      end
    else
      nil
    end
  end

  # def debit_mountpay
  #   # Potong Mountpay
  #   user = User.find(self.user_id)
  #   user.mountpay_debitkan(self.amount, self.desc)
  #   # BuyPpobJob.perform_at(2.seconds.from_now, self.ref_id, self.body_params.to_json)
  #   BuyPpobJob.perform_at(2.seconds.from_now, self.to_json)
  # end

  def reverse_balance
    # Kembalikan Mountpay
    user = User.find(self.user_id)
    user.mountpay_creditkan(self.amount, "Failed-#{self.desc}")
  end
end
