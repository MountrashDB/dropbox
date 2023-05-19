# == Schema Information
#
# Table name: user_vas
#
#  id         :bigint           not null, primary key
#  active     :boolean
#  bank_name  :string(255)
#  expired    :datetime
#  fee        :float(24)
#  kodeBank   :string(255)
#  name       :string(255)
#  rekening   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_user_vas_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require "net/http"
require "openssl"

class UserVa < ApplicationRecord
  belongs_to :user

  @@url = Rails.application.credentials.linkqu[:url]
  @@username = Rails.application.credentials.linkqu[:username]
  @@pin = Rails.application.credentials.linkqu[:pin]

  def self.create_va(user_id, bankcode)
    user = User.find(user_id)
    userva = UserVa.select(:bank_name, :rekening, :name, :fee).find_by(user_id: user.id, kodeBank: bankcode)
    if userva
      true
    else
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
          "bank_code": bankcode,
          "customer_id": "test14|" + user.uuid.to_s,
          "customer_name": user.username,
          "customer_phone": user.phone,
          "customer_email": user.email,
        }
        request.body = JSON.dump(data)
        response = https.request(request)
        result = JSON.parse(response.read_body)
        if result["status"] == "SUCCESS"
          hasil = UserVa.create!(
            user_id: user.id,
            kodeBank: bankcode,
            name: user.username,
            rekening: result["virtual_account"],
            fee: result["feeadmin"],
            bank_name: result["bank_name"],
          )
          true
        else
          false
        end
      rescue
        logger.error "=== Error create VA ==="
        logger.error "UserId " + user.id.to_s
        false
      end
    end
  end
end
