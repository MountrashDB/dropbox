class Api::V1::LoginController < AdminController
    before_action :check_token, except: [:login, :forgot]

    if Rails.env.production?
        @@token_expired  = 3.days.to_i
    else
        @@token_expired  = 30.days.to_i
    end

    def login
        if params[:email] && params[:password]
            admin = Admin.find_by(email: params[:email], active: true)
            if admin && admin.valid_password?(params[:password])
                payload = {
                    admin_id: admin.id,
                    exp: Time.now.to_i + @@token_expired
                }
                token = JWT.encode payload, Rails.application.credentials.secret_key_base, Rails.application.credentials.token_algorithm
                render json: {admin: admin, token: token}, status: :ok
            else
                render json: {error: true}, status: :unauthorized
            end
        else
            render json: {error: true, message: I18n.t('error.parameter_not_complete')}, status: :bad_request
        end
    end
end