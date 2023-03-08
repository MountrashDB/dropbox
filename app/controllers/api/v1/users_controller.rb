class Api::V1::UsersController < AdminController
  before_action :check_admin_token, only: [
    :show,
    :datatable,
    :destroy
  ]

  before_action :check_user_token, only: [
    :scan
  ]

  if Rails.env.production?
    @@token_expired  = 3.days.to_i
  else
    @@token_expired  = 30.days.to_i
  end


  def index
    render json: User.all
  end

  def show
    user = User.find_by(uuid: params[:uuid])
    if user
      render json: user
    else
      render json: {message: "Not found"}, status: :not_found
    end
  end

  def datatable    
    render json: UserDatatable.new(params)    
  end

  def register
    user = User.new()
    user.username = params[:username]
    user.email = params[:email]
    user.phone = params[:phone]
    user.password = params[:password]
    user.password_confirmation = params[:password_confirmation]
    if user.save
      render json: UserBlueprint.render(user, view: :register)
    else
      render json: user.errors
    end
  end

  def active_code
    if user = User.find_by(active_code: params[:code])
      user.active = 1
      user.active_code = nil
      user.save
      render json: UserBlueprint.render(user, view: :register)
    else
      render json: {message: "Not found"}, status: :not_found
    end    
  end

  def login
    if user = User.find_by(email: params[:email], active: true)
      if user.valid_password?(params[:password])
        payload = {
            user_uuid: user.uuid,
            exp: Time.now.to_i + @@token_expired
        }
        token = JWT.encode payload, Rails.application.credentials.secret_key_base, Rails.application.credentials.token_algorithm
        render json: {token: token, email: user.email, username: user.username}
      else
        render json: {message: "Not found"}, status: :unauthorized
      end
    else
      render json: {message: "Not found"}, status: :unauthorized
    end
  end

  def create
    user = User.new()
    user.username = params[:name]
    user.email = params[:email]
    user.phone = params[:phone]
    user.password = params[:password]
    user.password_confirmation = params[:password_confirmation]
    if user.save
      render json: user
    else
      render json: user.errors
    end
  end

  def update
    user = User.find_by(uuid: params[:uuid])
    if user
      user.name = params[:name]
      user.email = params[:email]      
      user.active = params[:active]
      user.save
      render json: user
    else
      render json: {message: "Not found"}, status: :not_found
    end    
  end

  def destroy    
    if user = User.find_by(uuid: params[:uuid])
      user.delete
      render json: {message: "Deleted"}
    else
      render json: {message: "Not found"}, status: :not_found
    end
  end

  def scan
    box = Box.find_by(uuid: params[:uuid])
    if box
      box.user_id = @current_user.id
      box.save
      render json: BoxBlueprint.render(box)
    else
      render json: {message: "Not found"}, status: :not_found
    end
  end

  private
end
