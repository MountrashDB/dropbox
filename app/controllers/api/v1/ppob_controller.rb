# https://api.iak.id/docs/reference/ZG9jOjEyNjIwNjcw-inquiry-telco-postpaid

# https://api.mountrash.online/ppob/iak/callback ---> Old callback mountrash
# 35.240.158.128 ---> IP mountrash
class Api::V1::PpobController < AdminController
  before_action :check_user_token, only: [
                                     :check_nomor,
                                     :harga,
                                     :prepaid_topup,
                                     :post_inquiry,
                                     :post_payment,
                                     :post_status,
                                   ]

  # Production
  @@prepaid_url = ENV["iak_prepaid"]
  @@username = ENV["iak_username"]
  @@api_key = ENV["iak_api_key"]
  @@sign = Digest::MD5.hexdigest @@username + @@api_key
  @@sign_prepaid = Digest::MD5.hexdigest @@username + @@api_key + "pl"
  @@postpaid_url = ENV["iak_postpaid"]

  # Development
  # @@prepaid_url = "https://prepaid.iak.dev"
  # @@postpaid_url = "https://testpostpaid.mobilepulsa.net"
  # @@username = ENV["iak_username"]
  # @@api_key = "86061ea4b7c25e81"
  # @@sign = Digest::MD5.hexdigest @@username + @@api_key
  # @@sign_prepaid = Digest::MD5.hexdigest @@username + @@api_key + "pl"

  @@profit = ENV["iak_profit"]

  @@pulsa_price_list = ["10000", "20000", "50000", "100000", "300000", "500000"]
  @@pln_price_list = ["20000", "50000", "100000", "500000", "1000000"]
  @@ovo_price_list = [10000, 20000, 50000, 100000, 300000, 500000]

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

  def filter_array_by_key(original_array, key_name, included_values)
    original_array.select { |item| included_values.include?(item[key_name]) }
  end

  def prepaid_price
    if permit_prepaid[:type] && permit_prepaid[:operator]
      price_list = Ppob.pricelist(permit_prepaid[:type], permit_prepaid[:operator])
      case permit_prepaid[:type]
      when "pulsa"
        filtered_array = filter_array_by_key(price_list, "product_nominal", @@pulsa_price_list)
      when "pln"
        filtered_array = filter_array_by_key(price_list, "product_nominal", @@pln_price_list)
      when "etoll"
        filtered_array = filter_array_by_key(price_list, "product_price", @@ovo_price_list)
      else
        filtered_array = filter_array_by_key(price_list, "product_nominal", @@pulsa_price_list)
      end
      if price_list
        render json: filtered_array.sort_by { |item| item["product_price"] }
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
      sign = Digest::MD5.hexdigest @@username + @@api_key + "pl"

      response = conn.post("/api/v1/bill/check/" + params[:type]) do |req|
        req.body = {
          commands: "pricelist-pasca",
          status: "active",
          username: @@username,
          sign: sign,
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
          vendor_price: hasil["data"]["price"].to_f,
          amount: hasil["data"]["price"].to_f + @@profit,
          profit: @@profit,
          ref_id: ref_id,
          tr_id: hasil["data"]["tr_id"],
          desc: "PPOB-#{hasil["data"]["tr_id"]}",
        )
      end
      render json: result
    else
      render json: { message: "Parameter not complete" }, status: :bad_request
    end
  end

  def post_payment
    if params[:tr_id]
      balance = @current_user.mountpay.balance
      ppob = Ppob.find_by(tr_id: params[:tr_id])
      harga_jual = ppob.vendor_price + @@profit
      if ppob
        if harga_jual < balance
          @current_user.mountpay_debitkan(harga_jual, ppob.desc)
          PostPaymentJob.perform_at(2.seconds.from_now)
          render json: { tr_id: params[:tr_id], status: "process" }
        else
          render json: { message: "Insuffient balance. Please select smaller price or product", balance: balance, price: harga_jual }, status: :bad_request
        end
      else
        render json: { message: "Data not found" }, status: :not_found
      end
    else
      render json: { message: "Parameter is not correct" }, status: :bad_request
    end
  end

  def post_status
    if params[:tr_id]
      ppob = Ppob.find_by(tr_id: params[:tr_id])
      if ppob
        render json: { status: ppob.status, body: ppob.body }
      else
        render json: { message: "Data not found" }, status: :not_found
      end
    else
      render json: { message: "Parameter is not correct" }, status: :bad_request
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

  def prepaid_inquiry_ovo
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
      response = conn.post("/api/inquiry-ovo") do |req|
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
    params.permit(:customer_id, :type, :operator, :product_code, :ppob, :price)
  end

  def permit_postpaid
    params.permit(:hp, :code, :type, :month, :price, :ppob)
  end
end
