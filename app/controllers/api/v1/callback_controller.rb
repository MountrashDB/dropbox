class Api::V1::CallbackController < ActionController::API
  require "uri"
  require "net/http"

  @@url = ENV["linkqu_url"]
  @@username = ENV["linkqu_username"]
  @@pin = ENV["linkqu_pin"]

  IAK_PROCESS = "0"
  IAK_SUCCESS = "1"
  IAK_FAILED = "2"

  def payment_linkqu
    ServerResponse.create(
      body: params,
      url: request.ip,
    )
    data = params[:partner_reff].split("|")
    id = data[1]
    trx = Withdrawl.find(id)
    status = params[:status]
    if status == "SUCCESS"
      trx.success!
    elsif status == "FAILED"
      trx.gagal!
    end
    render json: { response: "ok" }
  end

  def va_user
    ServerResponse.create(
      body: params,
      url: request.ip,
    )
    data = params[:partner_reff].split("|")
    id = data[1]
    trx = Withdrawl.find(id)
    status = params[:status]
    if status == "SUCCESS"
      trx.success!
    elsif status == "FAILED"
      trx.gagal!
    end
    render json: { response: "ok" }
  end

  def topup
    ServerResponse.create(
      body: params,
      url: request.ip,
    )
    data = params[:partner_reff].split("|")
    uuid = data[2]
    logger.error "=== UUID ==="
    logger.error uuid
    tipe = data[1]
    if tipe == "user"
      user = User.find_by(uuid: uuid)
      if user && params[:status] == "SUCCESS"
        user.mountpay_creditkan(params[:credit_balance], params[:type])
      end
    elsif tipe == "bsi"
      bsi = Banksampah.find_by(uuid: uuid)
      if bsi && params[:status] == "SUCCESS"
        logger.info "=== MASUK ==="
        bsi.mountpay_creditkan(params[:credit_balance], params[:type])
      end
    end
    render json: { response: "ok" }
  end

  def iak
    ServerResponse.create(
      body: params,
      url: request.ip,
    )
    logger.info "=== IAK Callback ==="
    data = params[:data]
    ppob = Ppob.find_by(ref_id: data["ref_id"])
    if ppob
      ppob.update(body: params.to_json)
      if data["status"] == IAK_SUCCESS
        ppob.successkan!
      elsif data["status"] == IAK_FAILED
        ppob.failedkan!
      end
    end
    render json: { response: "ok" }
  end
end
