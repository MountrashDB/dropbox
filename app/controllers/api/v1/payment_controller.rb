class Api::V1::PaymentController < ApiController
  require "uri"
  require "net/http"

  require "async/http/faraday"

  @@url = ENV["linkqu_url"]
  @@username = ENV["linkqu_username"]
  @@pin = ENV["linkqu_pin"]

  def bank_list
    Rails.cache.fetch("banks-list-v6", expires_in: 24.hours) do
      begin
        Faraday.default_adapter = :async_http
        response = Faraday.get(@@url + "/linkqu-partner/masterbank/list", {
          "Content-Type" => "application/json",
          "client-id" => ENV["linkqu_client_id"],
          "client-secret" => ENV["linkqu_client_secret"],
        })
        results = JSON.parse(response.body)
        Bank.delete_all
        results["data"].each do |d|
          Bank.create!(
            kode_bank: d["kodeBank"],
            name: d["namaBank"],
            is_active: d["isActive"],
          )
        end
      rescue Exception => e
        logger.error "=== FAILED Get bank list ==="
        logger.error e
      end
    end
    render json: Bank.order(name: :asc)
  end

  def bank_validation
    # begin
    url = URI.parse(@@url + "/linkqu-partner/transaction/withdraw/inquiry")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request["client-id"] = ENV["linkqu_client_id"]
    request["client-secret"] = ENV["linkqu_client_secret"]
    data = {
      "username": @@username,
      "pin": @@pin,
      "bankcode": params[:bankcode],
      "amount": params[:amount],
      "accountnumber": params[:accountnumber],
      "partner_reff": "20211223124530",
      "sendername": "Dropbox",
      "category": "04",
    }

    request.body = JSON.dump(data)
    response = https.request(request)
    result = JSON.parse(response.read_body)
    render json: result
    # rescue
    #   render json: { message: "failed" }, status: :not_found
    # end
  end
end
