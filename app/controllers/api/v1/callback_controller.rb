class Api::V1::CallbackController < ActionController::API
  require "uri"
  require "net/http"

  @@url = Rails.application.credentials.linkqu[:url]
  @@username = Rails.application.credentials.linkqu[:username]
  @@pin = Rails.application.credentials.linkqu[:pin]

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
    user = User.find_by(uuid: uuid)
    if user && params[:status] == "SUCCESS"
      user.mountpay_creditkan(params[:credit_balance], params[:type])
    end
    render json: { response: "ok" }
  end
end
