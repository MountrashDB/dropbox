require "net/http"
require "openssl"

class SendMoneyJob
  include Sidekiq::Job
  sidekiq_options retry: 0

  @@url = ENV["linkqu_url"]
  @@username = ENV["linkqu_username"]
  @@pin = ENV["linkqu_pin"]
  @@client_id = ENV["linkqu_client_id"]
  @@client_secret = ENV["linkqu_client_secret"]
  @@fee = ENV["linkqu_fee"]

  def perform(id)
    trx = Withdrawl.find(id)
    if trx.user_id
      user = User.find(trx.user_id)
      balance = user.usertransactions.balance
      tipe = "user"
    else
      mitra = Mitra.find(trx.mitra_id)
      balance = mitra.mitratransactions.balance
      tipe = "mitra"
    end
    begin
      # Inquiry before payment
      url = URI.parse(@@url + "/linkqu-partner/transaction/withdraw/inquiry")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request["client-id"] = @@client_id
      request["client-secret"] = @@client_secret
      partner_reff = tipe + "|" + id.to_s
      data = {
        "username": @@username,
        "pin": @@pin,
        "bankcode": trx.kodeBank,
        "amount": trx.amount,
        "accountnumber": trx.rekening,
        "accountname": trx.nama,
        "partner_reff": partner_reff,
        "sendername": "SmartDropbox",
        "customeridentity": tipe,
        "category": "03",
      }
      request.body = JSON.dump(data)
      response = https.request(request)
      result = JSON.parse(response.read_body)
      inquiry_reff = result["inquiry_reff"]

      # Payment
      url = URI.parse(@@url + "/linkqu-partner/transaction/withdraw/payment")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request["client-id"] = @@client_id
      request["client-secret"] = @@client_secret
      data = {
        "username": @@username,
        "pin": @@pin,
        "bankcode": trx.kodeBank,
        "amount": trx.amount,
        "accountnumber": trx.rekening,
        "accountname": trx.nama,
        "partner_reff": partner_reff,
        "sendername": "SmartDropbox",
        "inquiry_reff": inquiry_reff,
        "customeridentity": tipe,
        "category": "03",
      }

      request.body = JSON.dump(data)
      response = https.request(request)
      result = JSON.parse(response.read_body)
      if result["status"] == "FAILED"
        logger.error "=== Failed WD ID #{trx.id} ==="
        logger.error result
        trx.gagal!
      elsif result["status"] == "FAILED"
        trx.success!
      end
    rescue #Reverse user balance
      trx.gagal!
      logger.error "=== Error WD #{trx.id} ==="
    end
  end
end
