class Api::V1::Partner::AdminController < PartnerController
  def home
    render json: { message: "ready" }
  end
end
