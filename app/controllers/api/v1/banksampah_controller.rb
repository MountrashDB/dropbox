class Api::V1::BanksampahController < AdminController
  include ActiveStorage::SetCurrent
  before_action :check_banksampah_token, only: [
                                           :profile,
                                         ]

  if Rails.env.production?
    @@token_expired = 3.days.to_i
  else
    @@token_expired = 30.days.to_i
  end

  def active
    render json: { message: "active" }
  end

  def active_code
    if banksampah = Banksampah.find_by(activation_code: params[:code])
      banksampah.active = true
      banksampah.activation_code = nil
      banksampah.save
      render json: { message: "Success" }
    else
      render json: { message: "Not found or Activation Code not match" }, status: :not_found
    end
  end

  def login
    if banksampah = Banksampah.find_by(email: params[:email], active: true)
      if banksampah.valid_password?(params[:password])
        payload = {
          banksampah_uuid: banksampah.uuid,
          exp: Time.now.to_i + @@token_expired,
        }
        token = JWT.encode payload, ENV["secret_key_base"], ENV["token_algorithm"]
        render json: { token: token, uuid: banksampah.uuid }
      else
        render json: { message: "Not found" }, status: :unauthorized
      end
    else
      render json: { message: "Not found" }, status: :unauthorized
    end
  end

  def datatable
    render json: BanksampahDatatable.new(params)
  end

  def profile
    data = Banksampah.left_outer_joins(:city).select("uuid", "banksampahs.name AS banksampah_name", "phone", "email", "address", "cities.name AS city_name").find_by(uuid: @current_banksampah.uuid)
    render json: data
  end

  def show
    if data = Banksampah.find_by(uuid: params[:uuid])
      render json: data
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  private

  def banksampah_params
    params.permit(:name, :phone, :address, :image, :password, :password_confirmation)
  end
end
