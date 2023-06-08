# https://api.iak.id/docs/reference/ZG9jOjEyNjIwNjcw-inquiry-telco-postpaid

# https://api.mountrash.online/ppob/iak/callback ---> Old callback mountrash
# 35.240.158.128 ---> IP mountrash
class Api::V1::PpobController < AdminController
  before_action :check_user_token, only: [
                                     :check_nomor,
                                     :harga,
                                     :post_inquiry,
                                     :prepaid_topup,
                                   ]

  # Production
  @@prepaid_url = Rails.application.credentials.iak[:prepaid]
  @@username = Rails.application.credentials.iak[:username]
  @@api_key = Rails.application.credentials.iak[:api_key]
  @@sign = Digest::MD5.hexdigest @@username + @@api_key
  @@sign_prepaid = Digest::MD5.hexdigest @@username + @@api_key + "pl"
  @@postpaid_url = Rails.application.credentials.iak[:postpaid]

  # Development
  # @@prepaid_url = "https://prepaid.iak.dev"
  # @@postpaid_url = "https://testpostpaid.mobilepulsa.net"
  # @@username = Rails.application.credentials.iak[:username]
  # @@api_key = "86061ea4b7c25e81"
  # @@sign = Digest::MD5.hexdigest @@username + @@api_key
  # @@sign_prepaid = Digest::MD5.hexdigest @@username + @@api_key + "pl"

  @@profit = Rails.application.credentials.iak[:profit]

  def check_nomor
    if par = params[:customer_id]
      phone = Phonelib.parse(par)
      if phone.valid?
        prefix = phone.national(false)[0, 4] # Get 4 first digits
        three_prefix = ["0895", "0896", "0897", "0898", "0899"]
        case phone.carrier.downcase
        when "telkomsel"
          operator = "telkomsel"
          icon = "https://cdn.mobilepulsa.net/img/logo/pulsa/small/telkomsel.png"
        when "indosat ooredoo hutchison"
          operator = three_prefix.include?(prefix) ? "three" : "indosat"
          icon = three_prefix.include?(prefix) ? "https://cdn.mobilepulsa.net/img/logo/pulsa/small/three.png" : "https://cdn.mobilepulsa.net/img/logo/pulsa/small/indosat.png"
        when "xl"
          operator = "xl"
          icon = "https://cdn.mobilepulsa.net/img/logo/pulsa/small/xl.png"
        when "axis"
          operator = "axis"
          icon = "https://cdn.mobilepulsa.net/img/logo/pulsa/small/axis.png"
        when "smartfren"
          operator = "smart"
          icon = "https://cdn.mobilepulsa.net/img/logo/pulsa/small/smart.png"
        else
          operator = ""
          icon = ""
        end
        result = {
          customer_id: phone.national(false),
          operator: operator,
          icon: icon,
        }
        render json: result
      else
        render json: { message: "Nomor HP tidak valid" }, status: :bad_request
      end
    end
  end

  def prepaid_price
    if permit_prepaid[:type] && permit_prepaid[:operator]
      price_list = Ppob.pricelist(permit_prepaid[:type], permit_prepaid[:operator])
      if price_list
        render json: price_list
      else
        render json: { message: "Coba lagi" }, status: :bad_request
      end
    else
      render json: { message: "Parameter not complete" }, status: :bad_request
    end
  end

  def prepaid_buy
    # if permit_prepaid[:type] && permit_prepaid[:operator]
    #   conn = Faraday.new(
    #     url: "https://prepaid.iak.id",
    #     headers: { "Content-Type" => "application/json" },
    #     request: { timeout: 3 },
    #   )
    #   ref_id = "user|#{@current_user.uuid}|prepaid|#{rand(1000..9999)}"
    #   body = {
    #     username: @@username,
    #     ref_id: ref_id,
    #     sign: @@sign,
    #   }
    #   response = conn.post("/api/top-up") do |req|
    #     req.body = body.merge(permit_postpaid).to_json
    #   end
    #   render json: response.body
    # else
    #   render json: { message: "Parameter not complete" }, status: :bad_request
    # end
    result = Ppob.prepaid_buy(@current_user, permit_prepaid)
    render json: result
  end

  def post_price
    if params[:type]
      conn = Faraday.new(
        url: @@postpaid_url,
        headers: { "Content-Type" => "application/json" },
        request: { timeout: 3 },
      )

      response = conn.post("/api/v1/bill/check/" + params[:type]) do |req|
        req.body = {
          commands: "pricelist-pasca",
          status: "active",
          username: @@username,
          sign: @@sign + "pl",
        }.to_json
      end
      render json: response.body
    else
      render json: { message: "Parameter not complete" }, status: :bad_request
    end
  end

  def post_inquiry
    if permit_postpaid.permitted?
      conn = Faraday.new(
        url: @@postpaid_url,
        headers: { "Content-Type" => "application/json" },
        request: { timeout: 5 },
      )
      ref_id = "user|#{@current_user.uuid}|postpaid|#{rand(1000..9999)}"
      sign = Digest::MD5.hexdigest @@username + @@api_key + ref_id
      body = {
        commands: "inq-pasca",
        username: @@username,
        ref_id: ref_id,
        sign: sign,
      }
      response = conn.post("/api/v1/bill/check") do |req|
        req.body = body.merge(permit_postpaid).to_json
      end

      result = response.body

      hasil = JSON.parse(response.body)
      if selling = hasil["data"]&.key?("selling_price")
        ppob = Ppob.create!(
          user: @current_user,
          body: hasil,
          ppob_type: permit_postpaid[:type],
          vendor_price: hasil["data"]["selling_price"].to_f,
          amount: hasil["data"]["selling_price"].to_f + @@profit,
          profit: @@profit,
          ref_id: ref_id,
          tr_id: hasil["data"]["tr_id"],
        )
      end
      render json: result
    else
      render json: { message: "Parameter not complete" }, status: :bad_request
    end
  end

  def prepaid_inquiry
    if permit_prepaid.permitted?
      conn = Faraday.new(
        url: @@prepaid_url,
        headers: { "Content-Type" => "application/json" },
        request: { timeout: 5 },
      )
      sign = Digest::MD5.hexdigest @@username + @@api_key + permit_prepaid[:customer_id]
      login_body = {
        username: @@username,
        sign: sign,
      }
      response = conn.post("/api/inquiry-pln") do |req|
        req.body = login_body.merge(permit_prepaid).to_json
      end
      result = response.body

      hasil = JSON.parse(response.body)
      render json: result
    else
      render json: { message: "Parameter not complete" }, status: :bad_request
    end
  end

  def prepaid_inquiry_pln
    if permit_prepaid.permitted?
      conn = Faraday.new(
        url: @@prepaid_url,
        headers: { "Content-Type" => "application/json" },
        request: { timeout: 5 },
      )
      sign = Digest::MD5.hexdigest @@username + @@api_key + permit_prepaid[:customer_id]
      login_body = {
        username: @@username,
        sign: sign,
      }
      response = conn.post("/api/inquiry-pln") do |req|
        req.body = login_body.merge(permit_prepaid).to_json
      end
      result = response.body

      hasil = JSON.parse(response.body)
      render json: result
    else
      render json: { message: "Parameter not complete" }, status: :bad_request
    end
  end

  def prepaid_topup
    balance = @current_user.mountpay.balance
    harga = Ppob.pricelist(permit_prepaid[:type], permit_prepaid[:operator], permit_prepaid[:product_code]) #Check last 24 hours price
    if harga
      harga_jual = harga + @@profit
      if harga_jual < balance
        ref_id = "user-#{@current_user.uuid}-prepaid-#{Time.now.to_i}"
        record = Ppob.create!(
          amount: harga_jual,
          profit: @@profit,
          ppob_type: permit_prepaid[:type],
          ref_id: ref_id,
          user_id: @current_user.id,
          body_params: permit_prepaid,
          desc: "PPOB-#{permit_prepaid[:product_code]}-#{permit_prepaid[:customer_id]}",
        )
        @current_user.mountpay_debitkan(harga_jual, record.desc)
        BuyPpobJob.perform_at(2.seconds.from_now, record.to_json)
        render json: { ref_id: ref_id, status: 0, message: "PROCESS" }
      else
        render json: { message: "Insuffient balance. Please select smaller price or product", balance: balance, price: harga_jual }, status: :bad_request
      end
    else
      render json: { message: "Price not found or parameter is not correct" }, status: :bad_request
    end
  end

  def prepaid_status
    if params[:ref_id]
      result = JSON.parse(Ppob.prepaid_status(params[:ref_id]))

      ppob = Ppob.find_by(ref_id: params[:ref_id])
      if ppob.ppob_type == "pln"
        selected_fields = result["data"].select { |key, _| ["status", "ref_id", "message", "sn"].include?(key) }
      else
        selected_fields = result["data"].select { |key, _| ["status", "ref_id", "message"].include?(key) }
      end
      render json: selected_fields
    else
      render json: { message: "Parameter is not correct" }, status: :bad_request
    end
  end

  private

  def permit_prepaid
    params.permit(:customer_id, :type, :operator, :product_code, :ppob)
  end

  def permit_postpaid
    params.permit(:hp, :code, :type)
  end
end
