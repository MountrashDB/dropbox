class Api::V1::UsersController < ApiController
  
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
        render json: UserBlueprint.render(user, view: :register)
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

  private
end
