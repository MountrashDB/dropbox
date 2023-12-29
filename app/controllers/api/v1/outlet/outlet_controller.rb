class Api::V1::Outlet::OutletController < AdminController
  before_action :check_outlet_token, except: [
                                      :login,
                                      :forgot_password
                                    ]  
  @@token_expired = 30.days.to_i
  
  def login
    if outlet = Outlet.find_by(email: params[:email], active: true)
      if outlet.valid_password?(params[:password])
        payload = {
          outlet_uuid: outlet.uuid,
          name: outlet.name,
          exp: Time.now.to_i + @@token_expired,
        }
        token = JWT.encode payload, ENV["secret_key_base"], ENV["token_algorithm"]
        render json: { token: token, email: outlet.email, name: outlet.name, uuid: outlet.uuid }
      else
        render json: { message: "Not found" }, status: :unauthorized
      end
    else
      render json: { message: "Not found" }, status: :unauthorized
    end
  end

  def change_password
    if params[:password] == params[:password_confirmation]
      outlet = Outlet.find_by(uuid: @current_outlet.uuid)
      outlet.update(password: params[:password])
      render json: {message: "Password successfull changed"}
    else
      render json: {message: "Failed change password"}, status: :bad_request
    end
  end

  def forgot_password
    outlet = Outlet.find_by(email: params[:email])
    if outlet
      newpassword = SecureRandom.base58
      outlet.update(password: newpassword)
      OutletMailer.forgot_password(outlet).deliver_now!
    end
    render json: { message: "If email found. We will send your new password" }    
  end

  def alamat_create
    alamat = OutletAlamat.new()
    alamat.name = params[:name]
    alamat.alamat = params[:alamat]
    alamat.pic = params[:pic]
    alamat.phone = params[:phone]
    alamat.outlet = @current_outlet
    if params[:foto]
      alamat.foto = params[:foto]
    end
    if alamat.save
      render json: alamat
    else
      render json: alamat.errors, status: :bad_request
    end
  end

  def alamat_list
    render json: OutletAlamatBlueprint.render(@current_outlet.outlet_alamats)
  end

  def alamat_show
    alamat = OutletAlamat.find_by(id: params[:id], outlet: @current_outlet)
    if alamat
      render json: OutletAlamatBlueprint.render(alamat)
    else
      render json: {message: "Record not found"}, status: :not_found
    end
  end

  def alamat_update
    alamat = OutletAlamat.find_by(id: params[:id], outlet: @current_outlet)
    if alamat
      alamat.name = params[:name]
      alamat.alamat = params[:alamat]
      alamat.pic = params[:pic]
      alamat.phone = params[:phone]
      alamat.outlet = @current_outlet
      if params[:foto]
        alamat.foto = params[:foto]
      end
      if alamat.save
        render json: alamat
      else
        render json: alamat.errors, status: :bad_request
      end
    else
      render json: {message: "Record not found"}, status: :not_found
    end
  end

  def alamat_destroy
    alamat = OutletAlamat.find_by(id: params[:id], outlet: @current_outlet)
    if alamat 
      alamat.destroy
      render json: {message: "Success deleted"}
    else
      render json: {message: "Record not found"}, status: :not_found
    end
  end
end
