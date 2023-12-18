class Api::V1::MitrasController < AdminController
  include ActiveStorage::SetCurrent
  before_action :check_mitra_token, only: [
                                      :create_kyc,
                                      :profile,
                                      :update_profile,
                                      :box_datatable,
                                      :balance,
                                      :transaction,
                                      :show_self_kyc,
                                      :bank_info,
                                      :bank_info_update,
                                      :withdraw,
                                      :va_create_multi,
                                    ]

  before_action :check_admin_token, only: [
                                      :show,
                                      :show_kyc,
                                      :mitra_kyc,
                                      :datatable,
                                      :active,
                                    ]

  if Rails.env.production?
    @@token_expired = 3.days.to_i
  else
    @@token_expired = 30.days.to_i
  end

  @@fee = ENV["linkqu_fee"].to_f  
  @@url = ENV["linkqu_url"]
  @@username = ENV["linkqu_username"]
  @@pin = ENV["linkqu_pin"]
  @@bank_code = "002" # 002 = Bank BRI
  

  def active
    render json: { message: "active" }
    # if params[:search]
    #   render json: Mitra.active.where("name LIKE ?", "%" + params[:search] + "%")
    # else
    #   render json: Mitra.active
    # end
  end

  def show
    mitra = Mitra.find_by(uuid: params[:uuid])
    if mitra
      render json: MitraBlueprint.render(mitra, view: :show)
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  def set_status #for approval
    kyc = Kyc.find_by(uuid: params[:uuid])
    if kyc
      kyc.update(status: params[:status])
      if params[:status] == 1
        Mitra.find(kyc.mitra_id).update(status: params[:status])
      end
      render json: { message: "Updated" }
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  def datatable
    render json: MitraDatatable.new(params)
  end

  def mitra_kyc
    render json: KycDatatable.new(params)
  end

  def show_self_kyc
    render json: KycBlueprint.render(Kyc.find_by(mitra_id: @current_mitra.id))
  end

  def show_kyc
    if kyc = Kyc.find_by(uuid: params[:uuid])
      render json: KycBlueprint.render(kyc)
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  def register
    mitra = Mitra.new()
    mitra.name = params[:name]
    mitra.email = params[:email]
    mitra.phone = params[:phone]
    mitra.password = params[:password]
    mitra.password_confirmation = params[:password_confirmation]
    begin
      headers = request.headers
      jwt = headers["Authorization"].split(" ").last
      partner = Partner.get_jwt(jwt)
      mitra.partner_id = partner.id
    rescue
      # Do nothing
    end
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
      render json: { message: "Not found" }, status: :not_found
    end
  end

  def destroy
    if mitra = Mitra.find_by(uuid: params[:uuid])
      mitra.delete
      render json: { message: "Deleted" }
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  def active_code
    if mitra = Mitra.find_by(activation_code: params[:code])
      mitra.status = 1
      mitra.activation_code = nil
      mitra.save
      render json: { message: "Success" }
    else
      render json: { message: "Not found or Activation Code not match" }, status: :not_found
    end
  end

  def login
    if mitra = Mitra.find_by(email: params[:email], status: 1)
      if mitra.valid_password?(params[:password])
        payload = {
          mitra_uuid: mitra.uuid,
          exp: Time.now.to_i + @@token_expired,
        }
        token = JWT.encode payload, ENV["secret_key_base"], ENV["token_algorithm"]
        kyc = Kyc.where(mitra_id: mitra.id).last
        render json: { token: token, kyc_status: kyc != nil ? kyc.status : -1, uuid: mitra.uuid, id: mitra.id }
      else
        render json: { message: "Not found" }, status: :unauthorized
      end
    else
      render json: { message: "Not found" }, status: :unauthorized
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
      render json: { message: "Success" }
    else
      render json: { error: kyc.errors }
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
          render json: { error: "Password not match" }
          return
        end
      end
      if mitra.save
        render json: mitra
      else
        render json: { error: mitra.errors }
      end
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  # Mitra's box
  def box_datatable
    render json: BoxDatatable.new(params, current_mitra: @current_mitra)
  end

  def mitra_active
    if params[:search]
      mitra = Mitra.active.where("name LIKE ?", "%" + params[:search] + "%")
      render json: MitraBlueprint.render(mitra, view: :profile)
    else
      render json: Mitra.active
    end
  end

  def balance
    trx = Mitratransaction.where(mitra_id: @current_mitra.id).last
    if trx
      render json: { balance: trx.balance }
    else
      render json: { balance: 0 }
    end
  end

  def transaction
    render json: TransactionDatatable.new(params, mitra_id: @current_mitra.id)
  end

  def forgot_password
    if mitra = Mitra.find_by(email: params[:email])
      raw, enc = Devise.token_generator.generate(Mitra, :reset_password_token)
      mitra.update(reset_password_token: enc, reset_password_sent_at: Time.now())
      render json: { message: "Success", token: enc }
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  def reset_password
    if mitra = Mitra.find_by(reset_password_token: params[:token])
      if mitra.reset_password(params[:new_password], params[:password_confirmation])
        render json: { message: "Success" }
      else
        render json: { error: mitra.errors }
      end
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  def bank_info
    mitra_bank = MitraBank.find_by(mitra_id: @current_mitra.id)
    if mitra_bank
      render json: {
        nama: mitra_bank.nama,
        nama_bank: mitra_bank.nama_bank,
        rekening: mitra_bank.rekening,
        kodeBank: mitra_bank.kodeBank,
        is_valid: mitra_bank.is_valid,
      }
    else
      render json: {
        message: "Empty",
      }
    end
  end

  def bank_info_update
    mitrabank = MitraBank.find_by(mitra_id: @current_mitra.id)
    bank_validation = Mitra.validate_bank(params[:kodeBank], params[:rekening], params[:nama].upcase)
    if mitrabank
      mitrabank.nama = params[:nama]
      mitrabank.nama_bank = params[:nama_bank]
      mitrabank.rekening = params[:rekening]
      mitrabank.kodeBank = params[:kodeBank]
      mitrabank.is_valid = bank_validation
      if mitrabank.save
        render json: mitrabank
      else
        render json: { error: mitrabank.errors }
      end
    else
      if mitrabank = MitraBank.create!(
        mitra_id: @current_mitra.id,
        nama: params[:nama],
        nama_bank: params[:nama_bank],
        rekening: params[:rekening],
        kodeBank: params[:kodeBank],
        is_valid: bank_validation,
      )
        render json: mitrabank
      else
        render json: { error: mitrabank.errors }
      end
    end
  end

  def withdraw
    mitra = Mitra.find(@current_mitra.id)
    balance = mitra.mitratransactions.balance
    if mitra.mitra_bank.is_valid?
      if params[:amount] + @@fee < balance
        Withdrawl.transaction do
          Mitratransaction.create!(
            mitra_id: @current_mitra.id,
            credit: 0,
            debit: @@fee,
            balance: balance - @@fee,
            description: "Withdraw Fee",
          )
          trx = Mitratransaction.create!(
            mitra_id: @current_mitra.id,
            credit: 0,
            debit: params[:amount],
            balance: balance - params[:amount] - @@fee,
            description: "Withdraw",
          )
          process = Withdrawl.new()
          process.amount = params[:amount]
          process.kodeBank = mitra.mitra_bank.kodeBank
          process.nama = mitra.mitra_bank.nama
          process.rekening = mitra.mitra_bank.rekening
          process.mitra = @current_mitra
          process.mitratransaction_id = trx.id
          if process.save
            render json: { message: "Success" }
          else
            render json: { error: process.errors }, status: :bad_request
            raise ActiveRecord::Rollback
          end
        end
      else
        render json: { message: "Insuffient Balance" }, status: :bad_request
      end
    else
      render json: { message: "Invalid user bank info. Please update correct bank information" }, status: :bad_request
    end
  end

  def va_create_multi
    if params[:bank_code]
      mitrava = MitraVa.select(:bank_name, :kodeBank, :rekening, :name).find_by(mitra_id: @current_mitra.id, kodeBank: params[:bank_code])
      if mitrava
        render json: { virtual_account: mitrava.rekening, status: "SUCCESS", customer_name: mitrava.name, response_desc: "Virtual Account Successfully Created" }
      else #Create new VA
        # begin
        conn = Faraday.new(
          url: @@url,
          headers: {
            "Content-Type" => "application/json",
            "client-id" => ENV["linkqu_client_id"],
            "client-secret" => ENV["linkqu_client_secret"],
          },
          request: { timeout: 3 },
        )
        # $path.$method.$bank_code.$customer_id.$customer_name.$customer_email.$client-id

        customer_id = "va|mitra|" + @current_mitra.uuid + "|" + rand(10000..99999).to_s
        bank_code = params[:bank_code]
        second_value = "#{bank_code}#{customer_id}#{@current_mitra.name}#{@current_mitra.email}#{ENV["linkqu_client_id"]}"
        signature = Banksampah.signature("/transaction/create/vadedicated/add", "POST", second_value)
        response = conn.post("/linkqu-partner/transaction/create/vadedicated/add") do |req|
          req.body = {
            username: @@username,
            pin: @@pin,
            bank_code: bank_code,
            customer_id: customer_id,
            customer_name: @current_mitra.name,            
            customer_email: @current_mitra.email,
            signature: signature,
          }.to_json
          req.options.timeout = 3
          # rescue => e
          #   logger.fatal "=== VA create failed ==="
        end
        result = JSON.parse(response.body)
        puts result
        if !result["virtual_account"].empty?
          hasil = MitraVa.create!(
            mitra_id: @current_mitra.id,
            kodeBank: params[:bank_code],
            name: result["customer_name"],
            rekening: result["virtual_account"],
            fee: result["feeadmin"],
            bank_name: result["bank_name"],
          )
        end
        render json: { virtual_account: result["virtual_account"], status: result["status"], customer_name: result["customer_name"], response_desc: result["response_desc"] }
      end
    else
      render json: { message: "Parameter not complete" }, status: :bad_request
    end
  end

  private

  def mitra_params
    params.permit(:name, :phone, :address, :image, :password, :password_confirmation)
  end
end
