class Api::V1::PaymentController < ApiController
  require "uri"
  require "net/http"

  @@url = Rails.application.credentials.linkqu[:url]
  @@username = Rails.application.credentials.linkqu[:username]
  @@pin = Rails.application.credentials.linkqu[:pin]

  def bank_list
    result = Bank.order(name: :asc)
    Rails.cache.fetch("banks", expires_in: 24.hours) do
      begin
        url = URI.parse(@@url + "/linkqu-partner/masterbank/list")
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        request = Net::HTTP::Get.new(url)
        request["client-id"] = Rails.application.credentials.linkqu[:client_id]
        request["client-secret"] = Rails.application.credentials.linkqu[:client_secret]
        response = https.request(request)
        results = JSON.parse(response.read_body)
        Bank.destroy_all
        results["data"].each do |d|
          Bank.create!(
            kode_bank: d["kodeBank"],
            name: d["namaBank"],
            is_active: d["isActive"],
          )
        end
        result = Bank.order(name: :asc)
      rescue Exception => e
        logger.error "=== FAILED Get bank list ==="
        logger.error e
      end
    end
    render json: result
  end

  def bank_validation
    # begin
    url = URI.parse(@@url + "/linkqu-partner/transaction/withdraw/inquiry")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request["client-id"] = Rails.application.credentials.linkqu[:client_id]
    request["client-secret"] = Rails.application.credentials.linkqu[:client_secret]
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
