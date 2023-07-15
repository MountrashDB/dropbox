class CreateVaJob
  include Sidekiq::Job
  sidekiq_options retry: 0

  @@url = ENV["linkqu_url"]
  @@username = ENV["linkqu_username"]
  @@pin = ENV["linkqu_pin"]

  def perform(user_id, bank_code)
    user = User.find(user_id)
    userva = UserVa.find_by(user_id: user_id)
    begin
      if userva
        url = URI.parse(@@url + "/linkqu-partner/transaction/create/vadedicated/update")
      else
        url = URI.parse(@@url + "/linkqu-partner/transaction/create/vadedicated/add")
      end
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request["client-id"] = ENV["linkqu_client_id"]
      request["client-secret"] = ENV["linkqu_client_secret"]
      data = {
        "username": @@username,
        "pin": @@pin,
        "bank_code": userva.nil? ? bank_code : userva.kodeBank,
        "customer_id": "va|user|" + user.uuid.to_s,
        "customer_name": user.username,
        "customer_phone": user.phone,
        "customer_email": user.email,
      }
      request.body = JSON.dump(data)
      response = https.request(request)
      result = JSON.parse(response.read_body)
      if result["status"] == "SUCCESS"
        if userva.nil?
          hasil = UserVa.create!(
            user_id: user.id,
            kodeBank: bank_code,
            name: user.username,
            rekening: result["virtual_account"],
            fee: result["feeadmin"],
            bank_name: result["bank_name"],
          )
        end
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
