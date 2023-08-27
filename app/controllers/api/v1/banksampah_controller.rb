class Api::V1::BanksampahController < AdminController
  include ActiveStorage::SetCurrent
  before_action :check_banksampah_token, only: [
                                           :profile,
                                           :inventory_list,
                                           :inventory_read,
                                           :inventory_update,
                                           :inventory_delete,
                                         ]

  if Rails.env.production?
    @@token_expired = 3.days.to_i
  else
    @@token_expired = 30.days.to_i
  end

  def active
    render json: { message: "active" }
  end

  def register
    bank = Banksampah.new()
    bank.address = params[:address]
    bank.email = params[:email]
    bank.name = params[:name]
    bank.phone = params[:phone]
    bank.city_id = params[:city_id]
    bank.district_id = params[:district_id]
    bank.province_id = params[:province_id]
    bank.password = params[:password]
    if bank.save
      render json: bank
    else
      render json: bank.errors
    end
  end

  def active_code
    if banksampah = Banksampah.find_by(activation_code: params[:code])
      banksampah.active = true
      banksampah.activation_code = nil
      banksampah.save
    else
      render "not_match"
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
        render json: { token: token, uuid: banksampah.uuid, id: banksampah.id }
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

  def tipe_sampah
    tipes = TipeSampah.all
    render json: tipes
  end

  def inventory_list
    harga = HargaSampah.where(banksampah_id: @current_banksampah.id)
    render json: HargaSampahBlueprint.render(harga)
  end

  def inventory_read
    render json: { message: "Read" }
  end

  def inventory_update
    harga = HargaSampah.find_by(banksampah_id: @current_banksampah.id, tipe_sampah_id: params[:tipe_id])
    if harga
      harga.harga_kg = params[:harga_kg]
      harga.harga_satuan = params[:harga_satuan]
      if harga.save
        render json: harga
      else
        render json: harga.errors
      end
    else
      harga = HargaSampah.new()
      harga.banksampah_id = @current_banksampah.id
      harga.tipe_sampah_id = params[:tipe_id]
      harga.harga_kg = params[:harga_kg]
      harga.harga_satuan = params[:harga_satuan]
      if harga.save
        render json: harga
      else
        render json: harga.errors
      end
    end
  end

  def inventory_delete
    harga = HargaSampah.find_by(banksampah_id: @current_banksampah.id, tipe_sampah_id: params[:tipe_id])
    if harga.delete
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  private

  def banksampah_params
    params.permit(:name, :phone, :address, :image, :password, :password_confirmation)
  end
end
