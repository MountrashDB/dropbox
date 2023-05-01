class Api::V1::PaymentController < ApiController
  require "uri"
  require "net/http"

  @@url = Rails.application.credentials.linkqu[:url]

  def bank_list
    begin
      url = URI.parse(@@url + "/linkqu-partner/masterbank/list")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Get.new(url)
      request["client-id"] = Rails.application.credentials.linkqu[:client_id]
      request["client-secret"] = Rails.application.credentials.linkqu[:client_secret]
      result = Rails.cache.fetch("masterbank_list", expires_in: 24.hours) do
        response = https.request(request)
        JSON.parse(response.read_body)
      end
    rescue
      result = []
    end
    render json: result
  end
end
