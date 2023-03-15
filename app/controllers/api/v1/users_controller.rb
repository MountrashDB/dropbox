class Api::V1::UsersController < AdminController
  include ActiveStorage::SetCurrent

  before_action :check_admin_token, only: [
    :show,
    :datatable,
    :destroy
  ]

  before_action :check_user_token, only: [
    :scan,
    :check_botol,
    :balance,
    :profile,
    :update_profile,
    :rewards
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

  def rewards    
    render json: TransactionDatatable.new(params, user_id: @current_user.id)    
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
        render json: {token: token, email: user.email, username: user.username, uuid: user.uuid, id: user.id}
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

  def update_profile
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

  def insert
    box = Box.find_by(uuid: params[:uuid])
    if box
      harga_botol = 300 # Nanti disesuaikan sesuai botol yang masuk
      mitra_amount = box.mitra_share * harga_botol / 100
      user_amount = box.user_share * harga_botol / 100
      
      transaction = Transaction.new()
      transaction.mitra = box.mitra
      transaction.user = box.user
      transaction.box_id = box.id
      transaction.harga = harga_botol
      transaction.diterima = true # Harus dimaintain jika botol valid atau tidak
      transaction.mitra_amount = mitra_amount
      transaction.user_amount = user_amount
      transaction.foto = params[:foto]
      if transaction.save
        render json: {message: "Success"}
      else
        render json: transaction.errors
      end
    else
      render json: {message: "Not found"}, status: :not_found
    end  
  end

  def check_botol    
    transaction = Transaction.where(user_id: @current_user.id).order(created_at: :desc).limit(1)
    render json: TransactionBlueprint.render(transaction, view: :check_botol)
  end

  def balance
    trx = Usertransaction.where(user_id: @current_user.id).last
    if trx
      render json: {balance: trx.balance}
    else
      render json: {balance: 0}
    end
  end

  def profile    
    render json: @current_user
  end

  def update_profile
    user = User.find(@current_user.id)
    if user
      user.username = params[:username] if params[:username]
      user.email = params[:email] if params[:email]
      user.phone = params[:phone] if params[:phone]
      if user.save
        render json: {message: "Success"}
      else
        render json: user.errors
      end
    else
      render json: {message: "Not found"}, status: :not_found
    end
  end

  private
end
