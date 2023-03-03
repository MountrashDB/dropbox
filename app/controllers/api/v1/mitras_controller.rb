class Api::V1::MitrasController < AdminController
  before_action :check_mitra_token, only: [
    :create_kyc,
    :profile,
    :update_profile
  ]

  before_action :check_admin_token, only: [
    :show,
    :show_kyc,
    :datatable
  ]

  if Rails.env.production?
    @@token_expired  = 3.days.to_i
  else
    @@token_expired  = 30.days.to_i
  end

  def index
    render json: Mitra.all
  end

  def show
    mitra = Mitra.find_by(uuid: params[:uuid])
    if mitra
      render json: MitraBlueprint.render(mitra, view: :show)
    else
      render json: {message: "Not found"}, status: :not_found
    end
  end

  def set_status #for approval
    kyc = Kyc.find_by(uuid: params[:uuid])
    if kyc
      kyc.update(status: params[:status])
      if params[:status] == 1
        Mitra.find(kyc.mitra_id).update(status: params[:status])
      end 
      render json: {message: "Updated"}
    else
      render json: {message: "Not found"}, status: :not_found
    end
  end

  def datatable    
    render json: MitraDatatable.new(params)    
  end

  def show_kyc
    if kyc = Kyc.find_by(uuid: params[:uuid])
      render json: KycBlueprint.render(kyc)
    else
      render json: {message: "Not found"}, status: :not_found
    end
  end

  def register
    mitra = Mitra.new()
    mitra.name = params[:name]
    mitra.email = params[:email]
    mitra.phone = params[:phone]
    mitra.password = params[:password]
    mitra.password_confirmation = params[:password_confirmation]
    if mitra.save
      render json: MitraBlueprint.render(mitra, view: :register)
    else
      render json: mitra.errors
    end
  end
  
  def create
    mitra = Mitra.new()
    mitra.name = params[:name]
    mitra.avatar = params[:avatar]
    mitra.contact = params[:contact]
    mitra.email = params[:email]
    mitra.phone = params[:phone]
    mitra.terms = params[:terms]
    mitra.address = params[:address]
    mitra.password = params[:password]
    mitra.password_confirmation = params[:password_confirmation]
    if mitra.save
      render json: mitra
    else
      render json: mitra.errors
    end
  end

  def update
    mitra = Mitra.find_by(uuid: params[:uuid])
    if mitra
      mitra.name = params[:name]
      mitra.contact = params[:contact]
      mitra.email = params[:email]
      mitra.phone = params[:phone]
      mitra.address = params[:address]
      mitra.save
      render json: mitra
    else
      render json: {message: "Not found"}, status: :not_found
    end    
  end

  def destroy    
    if mitra = Mitra.find_by(uuid: params[:uuid])
      mitra.delete
      render json: {message: "Deleted"}
    else
      render json: {message: "Not found"}, status: :not_found
    end
  end

  def active_code
    if mitra = Mitra.find_by(activation_code: params[:code])
      mitra.status = 1
      mitra.activation_code = nil
      mitra.save
      render json: {message: "Success"}
    else
      render json: {message: "Not found or Activation Code not match"}, status: :not_found
    end
  end

  def login
    if mitra = Mitra.find_by(email: params[:email], status: 1)
      if mitra.valid_password?(params[:password])
        payload = {
            mitra_uuid: mitra.uuid,
            exp: Time.now.to_i + @@token_expired
        }
        token = JWT.encode payload, Rails.application.credentials.secret_key_base, Rails.application.credentials.token_algorithm        
        kyc = Kyc.where(mitra_id: mitra.id).last
        render json: {token: token, kyc_status: kyc != nil ? kyc.status : nil}
      else
        render json: {message: "Not found"}, status: :unauthorized
      end
    else
      render json: {message: "Not found"}, status: :unauthorized
    end
  end

  def create_kyc
    kyc = Kyc.new()
    kyc.agama = params[:agama]
    kyc.desa = params[:desa]
    kyc.nama = params[:nama]
    kyc.no_ktp = params[:no_ktp]
    kyc.pekerjaan = params[:pekerjaan]
    kyc.rt = params[:rt]
    kyc.rw = params[:rw]
    kyc.tempat_tinggal = params[:tempat_tinggal]
    kyc.tgl_lahir = params[:tgl_lahir]
    kyc.province_id = params[:province_id]
    kyc.city_id = params[:city_id]
    kyc.district_id = params[:district_id]
    kyc.ktp_image.attach(params[:ktp_image])
    kyc.mitra_id = @current_mitra.id
    if kyc.save
      render json: {message: "Success"}
    else
      render json: {error: kyc.errors}
    end
  end

  def profile
    render json: MitraBlueprint.render(@current_mitra, view: :profile)
  end

  def update_profile
    mitra = Mitra.find(@current_mitra.id)      
    if mitra
      mitra.name = params[:name]
      mitra.phone = params[:phone]
      mitra.address = params[:address]
      if params[:image]
        mitra.image.attach(params[:image])
      end
      if params[:password]
        if mitra.valid_password?(params[:old_password]) && params[:password] == params[:password_confirmation]
          mitra.reset_password(params[:password], params[:password_confirmation])
        else
          render json: {error: "Password not match"}
          return
        end
      end
      if mitra.save   
        render json: mitra
      else 
        render json: {error: mitra.errors}
      end
    else
      render json: {message: "Not found"}, status: :not_found
    end    
  end

  private

  def check_mitra_token      
    begin       
      if !@current_mitra = Mitra.get_mitra(request.headers)   
        render json: {error: true}, status: :unauthorized
      end
    rescue
      render json: {error: true}, status: :unauthorized
    end
  end

  def mitra_params
    params.permit(:name, :phone, :address, :image, :password, :password_confirmation)
  end
end
