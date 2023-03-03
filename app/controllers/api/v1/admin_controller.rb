class Api::V1::AdminController < AdminController
    before_action :check_admin_token, except: [
        :login
    ]

    if Rails.env.production?
        @@token_expired  = 3.days.to_i
    else
        @@token_expired  = 30.days.to_i
    end
    
    def login
        if admin = Admin.find_by(email: params[:email], active: true)
          if admin.valid_password?(params[:password])
            payload = {
                admin_uuid: admin.uuid,
                exp: Time.now.to_i + @@token_expired
            }
            token = JWT.encode payload, Rails.application.credentials.secret_key_base, Rails.application.credentials.token_algorithm
            render json: {token: token, email: admin.email, first_name: admin.first_name, last_name: admin.last_name}
          else
            render json: {message: "Not found"}, status: :unauthorized
          end
        else
          render json: {message: "Not found"}, status: :unauthorized
        end
    end

    def change_password
        @current_admin.password = params[:password]
        @current_admin.password_confirmation = params[:password_confirmation]
        if @current_admin.save
            render json: {message: "Success"}
        else
            render json: {error: @current_admin.errors}
        end
    end
end
