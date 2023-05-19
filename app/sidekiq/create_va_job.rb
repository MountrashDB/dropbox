class CreateVaJob
  include Sidekiq::Job
  sidekiq_options retry: 0

  @@url = Rails.application.credentials.linkqu[:url]
  @@username = Rails.application.credentials.linkqu[:username]
  @@pin = Rails.application.credentials.linkqu[:pin]

  def perform(user_id, bank_code)
    user = User.find(user_id)
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
        "bank_code": bank_code,
        "customer_id": "va|user|" + user.uuid.to_s,
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
          kodeBank: bank_code,
          name: user.username,
          rekening: result["virtual_account"],
          fee: result["feeadmin"],
          bank_name: result["bank_name"],
        )
      else
        logger.error "=== Failed create VA ==="
        logger.error result
      end
    rescue Exception => e
      logger.error "=== Error create VA ==="
      logger.error @@url
      logger.error e
      logger.error "UserId " + user.id.to_s
    end
  end
end
