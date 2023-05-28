class Api::V1::PpobController < AdminController
  before_action :check_user_token, only: [
                                     :harga,
                                   ]

  @@url = "https://mobilepulsa.net"
  @@prepaid = Rails.application.credentials.iak[:prepaid]
  @@username = Rails.application.credentials.iak[:username]
  @@api_key = Rails.application.credentials.iak[:api_key]
  @@sign = Digest::MD5.hexdigest @@username + @@api_key + "pl"

  def post_price
    if params[:type]
      conn = Faraday.new(
        url: @@url,
        headers: { "Content-Type" => "application/json" },
      )

      response = conn.post("/api/v1/bill/check/" + params[:type]) do |req|
        req.body = {
          commands: "pricelist-pasca",
          status: "active",
          username: @@username,
          sign: @@sign,
        }.to_json
      end
      render json: response.body
    else
      render json: { message: "Parameter not complete" }, status: :bad_request
    end
  end

  def post_inq
    if params[:type]
      conn = Faraday.new(
        url: @@url,
        headers: { "Content-Type" => "application/json" },
      )

      response = conn.post("/api/v1/bill/check/" + params[:type]) do |req|
        req.body = {
          commands: "inq-pasca",
          ref_id: "",
          code: "inq-user",
          username: @@username,
          sign: @@sign,
        }.to_json
      end
      render json: response.body
    else
      render json: { message: "Parameter not complete" }, status: :bad_request
    end
  end
end
