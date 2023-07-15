class PostPaymentJob
  include Sidekiq::Job
  sidekiq_options retry: 3

  # Production
  @@username = ENV["iak_username"]
  @@api_key = ENV["iak_api_key"]
  @@sign = Digest::MD5.hexdigest @@username + @@api_key
  @@postpaid_url = ENV["iak_postpaid"]

  def perform(ppob)
    logger.info "=== PAY PPOB ==="
    ppob = Ppob.find(ppob.id)
    conn = Faraday.new(
      url: @@prepaid_url,
      headers: { "Content-Type" => "application/json" },
      request: { timeout: 3 },
    )
    ref_id = ppob.ref_id
    sign = Digest::MD5.hexdigest @@username + @@api_key + ppob.tr_id.to_s
    body = {
      commands: "pay-pasca",
      tr_id: ppob.tr_id,
      username: @@username,
      sign: sign,
    }
    response = conn.post("/api/v1/bill/check") do |req|
      req.body = body.to_json
    end
    ppob.update(body: response.body) # Save body response
  end
end
