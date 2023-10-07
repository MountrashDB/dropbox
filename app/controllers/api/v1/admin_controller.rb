class Api::V1::AdminController < AdminController
  include ActiveStorage::SetCurrent

  before_action :check_admin_token, except: [
                                      :login,
                                    ]

  if Rails.env.production?
    @@token_expired = 3.days.to_i
  else
    @@token_expired = 30.days.to_i
  end

  def login
    if admin = Admin.find_by(email: params[:email], active: true)
      if admin.valid_password?(params[:password])
        payload = {
          admin_uuid: admin.uuid,
          exp: Time.now.to_i + @@token_expired,
        }
        token = JWT.encode payload, ENV["secret_key_base"], ENV["token_algorithm"]
        render json: { token: token, email: admin.email, first_name: admin.first_name, last_name: admin.last_name }
      else
        render json: { message: "Not found" }, status: :unauthorized
      end
    else
      render json: { message: "Not found" }, status: :unauthorized
    end
  end

  def change_password
    @current_admin.password = params[:password]
    @current_admin.password_confirmation = params[:password_confirmation]
    if @current_admin.save
      render json: { message: "Success" }
    else
      render json: { error: @current_admin.errors }
    end
  end

  def create
    admin = Admin.new()
    admin.email = params[:email]
    admin.first_name = params[:first_name]
    admin.last_name = params[:last_name]
    admin.active = params[:active]
    admin.password = params[:password]
    admin.password_confirmation = params[:password_confirmation]
    if admin.save
      admin.image.attach(params[:image]) if params[:image]
      render json: AdminBlueprint.render(admin)
    else
      render json: { error: admin.errors }
    end
  end

  def update
    admin = Admin.find_by(uuid: params[:uuid])
    if admin
      admin.email = params[:email]
      admin.first_name = params[:first_name]
      admin.last_name = params[:last_name]
      admin.active = params[:active]
      if params[:password]
        admin.reset_password(params[:password], params[:password_confirmation])
        render json: AdminBlueprint.render(admin)
      else
        render json: { error: "Password not match" }
        return
      end
      if admin.save
        admin.image.attach(params[:image]) if params[:image]
        render json: { message: "Success" }
      else
        render json: { error: admin.errors }
      end
    else
      render json: { message: "Not found" }
    end
  end

  def destroy
    admin = Admin.find_by(uuid: params[:uuid])
    if admin
      admin.delete
      render json: { message: "Success" }
    else
      render json: { message: "Not found" }
    end
  end

  def datatable
    render json: AdminDatatable.new(params, current_admin: @current_admin)
  end

  def show
    admin = Admin.find_by(uuid: params[:uuid])
    if admin
      render json: AdminBlueprint.render(admin)
    else
      render json: { message: "Not found" }
    end
  end

  def transaction
    render json: TransactionDatatable.new(params)
  end

  def harga_jual
    render json: BotolhargaDatatable.new(params)
  end

  def transaction_process
    trx = Transaction.find_by(uuid: params[:uuid])
    if trx
      trx.update!(diterima: params[:diterima])
      render json: trx
    else
      render json: { message: "Not found" }
    end
  end

  # def transaction_delete
  #   trx = Transaction.find_by(uuid: params[:uuid])
  #   if trx
  #     trx.destroy
  #     render json: { message: "Deleted" }
  #   else
  #     render json: { message: "Not found" }
  #   end
  # end

  def transaction_delete
    if params[:uuids]
      Transaction.where(uuid: params[:uuids]).destroy_all
      render json: { message: "Deleted" }
    else
      render json: { message: "Parameter not complete" }
    end
  end

  def withdrawl
    render json: WithdrawlDatatable.new(params)
  end

  def withdrawl_read
    if withdraw = Withdrawl.find_by(id: params[:id])
      render json: WithdrawlBlueprint.render(withdraw)
    else
      render json: { message: "Record not found" }, status: :not_found
    end
  end

  def withdrawl_proses
    if withdraw = Withdrawl.find_by(id: params[:id])
      begin
        if params[:status] == "approved"
          withdraw.approved!
          render json: withdraw
        elsif params[:status] == "rejected"
          withdraw.rejected!
          render json: withdraw
        else
          render json: { message: "Wrong parameter or value" }, status: :bad_request
        end
      rescue => e
        render json: { message: e }
      end
    else
      render json: { message: "Record not found" }, status: :not_found
    end
  end

  def bsi_show
    bsi = Banksampah.find_by(uuid: params[:banksampah_uuid])
    if bsi
      render json: BankSampahBlueprint.render(bsi, view: :full)
    else
      render json: { message: "Record not found" }, status: :not_found
    end
  end

  def banksampah_datatable
    render json: BanksampahDatatable.new(params)
  end

  def manual_transfer
    bsi = Banksampah.find_by(uuid: params[:banksampah_uuid])
    if params[:amount].to_i >= 10000 && bsi
      description = "Manual Tf, #{params[:description]}"
      bsi.mountpay_creditkan(params[:amount].to_i, description)
      render json: { message: "Success", balance: bsi.mountpay.balance }
    else
      render json: { message: "Record not found or amount cannot below 10000" }, status: :not_found
    end
  end

  def bsi_update
    bsi = Banksampah.find_by(uuid: params[:banksampah_uuid])
    if bsi.update(bsi_params)
    else
      render json: { message: "Record not found" }, status: :not_found
    end
  end

  def bsi_destroy
    bsi = Banksampah.find_by(uuid: params[:uuid])
    if bsi
      bsi.destroy!
      render json: { message: "Deleted" }
    else
      render json: { message: "Record not found" }, status: :not_found
    end
  end

  private

  def bsi_params
    params.permit(:phone, :name, :active)
  end
end
