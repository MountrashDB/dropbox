class BuyPpobJob
  include Sidekiq::Job
  sidekiq_options retry: 0

  # Production
  # @@prepaid_url = Rails.application.credentials.iak[:prepaid]
  # @@username = Rails.application.credentials.iak[:username]
  # @@api_key = Rails.application.credentials.iak[:api_key]
  # @@sign = Digest::MD5.hexdigest @@username + @@api_key
  # @@sign_prepaid = Digest::MD5.hexdigest @@username + @@api_key + "pl"
  # @@postpaid_url = Rails.application.credentials.iak[:postpaid]

  # Development
  @@prepaid_url = "https://prepaid.iak.dev"
  @@postpaid_url = "https://testpostpaid.mobilepulsa.net"
  @@username = Rails.application.credentials.iak[:username]
  @@api_key = "86061ea4b7c25e81"
  @@sign = Digest::MD5.hexdigest @@username + @@api_key
  @@sign_prepaid = Digest::MD5.hexdigest @@username + @@api_key + "pl"

  def perform(ppob)
    data = JSON.parse(ppob)
    ppob = Ppob.find(data["id"])

    conn = Faraday.new(
      url: @@prepaid_url,
      headers: { "Content-Type" => "application/json" },
      request: { timeout: 3 },
    )
    ref_id = ppob.ref_id
    sign = Digest::MD5.hexdigest @@username + @@api_key + ref_id
    body = {
      username: @@username,
      ref_id: ref_id,
      sign: sign,
    }
    response = conn.post("/api/top-up") do |req|
      req.body = body.merge(ppob.body_params).to_json
    end
    ppob.update(body: response.body) # Save body response
  end
end
