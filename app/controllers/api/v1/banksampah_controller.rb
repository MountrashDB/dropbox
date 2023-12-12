class Api::V1::BanksampahController < AdminController
  include ActiveStorage::SetCurrent
  # Test
  before_action :check_banksampah_token, only: [
                                           :profile,
                                           :inventory_list,
                                           :inventory_read,
                                           :inventory_update,
                                           :inventory_delete,
                                           :sampah_create,
                                           :sampah_read,
                                           :sampah_update,
                                           :sampah_delete,
                                           :datatable,
                                           :order_sampah_read,
                                           :order_sampah_update,
                                           :order_datatable,
                                           :order_sampah_proses,
                                           :order_sampah_payment,
                                           :va_create_multi,
                                           :va_list,
                                           :balance,
                                         ]

  if Rails.env.production?
    @@token_expired = 3.days.to_i
  else
    @@token_expired = 30.days.to_i
  end

  @@fee_sampah = 2.5 # In percentage
  @@fee = ENV["linkqu_fee"].to_f
  @@url = ENV["linkqu_url"]
  @@client_id = ENV["linkqu_client_id"]
  @@username = ENV["linkqu_username"]
  @@pin = ENV["linkqu_pin"]
  @@bank_code = "002" # 002 = Bank BRI

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
      render json: bank.errors, status: :bad_request
    end
  end

  def resend
    if banksampah = Banksampah.find_by(email: params[:email])
      BanksampahMailer.welcome_email(banksampah).deliver_now!
      render json: { message: "Sent" }
    else
      render json: { message: "Not found" }, status: :not_found
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

  def sampah_create
    sampah = Sampah.new(sampah_params)
    sampah.banksampah_id = @current_banksampah.id
    if sampah.save
      render json: sampah
    else
      render json: sampah.errors
    end
  end

  def sampah_read
    sampah = Sampah.find_by(uuid: params[:uuid], banksampah_id: @current_banksampah.id)
    if sampah
      render json: sampah
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  def sampah_update
    sampah = Sampah.find_by(uuid: params[:uuid], banksampah_id: @current_banksampah.id)
    if sampah.update(sampah_params)
      render json: sampah
    else
      render json: sampah.errors, status: :bad_request
    end
  end

  def sampah_delete
    sampah = Sampah.find_by(uuid: params[:uuid], banksampah_id: @current_banksampah.id)
    if sampah
      sampah.destroy
      render json: sampah
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  def datatable
    render json: SampahDatatable.new(params, current_banksampah: @current_banksampah)
  end

  def order_sampah_read
    if params[:uuid]
      orderan = OrderSampah.find_by(uuid: params[:uuid], banksampah_id: @current_banksampah.id)
      if orderan
        render json: { order: OrderSampahBlueprint.render_as_json(orderan), items: OrderDetailBlueprint.render_as_json(orderan.order_details) }
      else
        render json: { message: "Not found" }, status: :not_found
      end
    else
      render json: { message: "Parameter not complete" }, status: :not_found
    end
  end

  def order_sampah_update
    if orderan = OrderSampah.find_by(uuid: params[:uuid], banksampah_id: @current_banksampah.id)
      if params[:_json] && orderan
        items = params[:_json]
        total = 0
        orderan.order_details.destroy_all
        items.each do |item|
          if item["sampah_id"] && item["qty"]
            harga = Sampah.find(item["sampah_id"])
            if harga
              if item["satuan"] == "kg"
                sub_total = harga.harga_kg * item["qty"].to_f
                harga_jual = harga.harga_kg
              else
                sub_total = harga.harga_satuan * item["qty"].to_f
                harga_jual = harga.harga_satuan
              end
              total = total + sub_total
              detail = OrderDetail.new()
              detail.order_sampah_id = orderan.id
              detail.sampah_id = item["sampah_id"]
              detail.harga = harga_jual
              detail.qty = item["qty"]
              detail.satuan = item["satuan"]
              detail.sub_total = sub_total
              if !detail.save
                render json: { error: detail.errors }
                return
              end
            end
          end
        end
        fee_sampah = @@fee_sampah / 100 * total
        orderan.sub_total = total
        orderan.total = fee_sampah + total
        orderan.save
        render json: { order: orderan, items: OrderDetailBlueprint.render_as_json(OrderDetail.where(order_sampah_id: orderan.id)) }
      else
        render json: { message: "At least one order item" }, status: :bad_request
      end
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  def order_datatable
    render json: OrderSampahDatatable.new(params, current_banksampah: @current_banksampah)
  end

  def order_sampah_proses
    if orderan = OrderSampah.find_by(uuid: params[:uuid], banksampah_id: @current_banksampah.id)
      if status = params[:status]
        begin
          if status == "accepted"
            orderan.diterima!
          else
            orderan.ditolak!
          end
          render json: orderan
        rescue
          render json: { message: "Cannot process or status cannot updated" }, status: :bad_request
        end
      else
        render json: { message: "Select status [rejected/accepted] " }, status: :bad_request
      end
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  def order_sampah_payment
    if orderan = OrderSampah.find_by(uuid: params[:uuid], banksampah_id: @current_banksampah.id)
      if orderan.status == "accepted"
        if orderan.sub_total < @current_banksampah.mountpay.balance
          orderan.paidkan!
          render json: { message: "Success", order: OrderSampahBlueprint.render_as_json(orderan) }
        else
          render json: { message: "Insufficient balance", total_order: orderan.total, balance: @current_banksampah.mountpay.balance }, status: :bad_request
        end
      else
        render json: { message: "This order cannot pay", order: OrderSampahBlueprint.render_as_json(orderan) }, status: :bad_request
      end
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  def va_create_multi
    bsiva = BsiVa.select(:bank_name, :kodeBank, :rekening, :name).find_by(banksampah_id: @current_banksampah.id, kodeBank: params[:bank_code])
    if bsiva
      render json: bsiva
    else
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
      customer_id = "va|bsi|" + @current_banksampah.uuid + "|" + rand(10000..99999).to_s
      second_value = "#{params[:bank_code]}#{customer_id}#{@current_banksampah.name}#{@current_banksampah.email}#{@@client_id}"
      signature = Banksampah.signature("/transaction/create/vadedicated/add", "POST", second_value)
      response = conn.post("/linkqu-partner/transaction/create/vadedicated/add") do |req|
        req.body = {
          username: @@username,
          pin: @@pin,
          bank_code: params[:bank_code],
          customer_id: customer_id,
          customer_name: @current_banksampah.name,
          customer_phone: @current_banksampah.phone,
          customer_email: @current_banksampah.email,
          signature: signature,
        }.to_json
        req.options.timeout = 3
      end
      result = JSON.parse(response.body)
      hasil = BsiVa.create!(
        banksampah_id: @current_banksampah.id,
        kodeBank: params[:bank_code],
        name: result["customer_name"],
        rekening: result["virtual_account"],
        fee: result["feeadmin"],
        bank_name: result["bank_name"],
      )
      render json: { bank_name: hasil.bank_name, kodeBank: hasil.kodeBank, name: hasil.name, rekening: hasil.rekening }
    end
  end

  def va_list
    render json: BsiVa.select(:bank_name, :rekening, :kodeBank, :name).where(banksampah_id: @current_banksampah.id)
  end

  def balance
    bsi = Banksampah.find(@current_banksampah.id)
    render json: { mountpay: bsi.mountpay.balance }
  end

  def forgot_password
    banksampah = Banksampah.find_by(email: params[:email])
    if banksampah
      # newpassword = SecureRandom.base58
      newpassword = "12345678"
      banksampah.update(password: newpassword)
      BanksampahMailer.forgot_password(banksampah).deliver_now!
    end
    render json: { message: "If email found. We will send your new password" }
    
  end

  private

  def sampah_params
    params.permit(
      :name,
      :code,
      :active,
      :description,
      :harga_kg,
      :harga_satuan,
      :banksampah_id,
      :tipe_sampah_id
    )
  end

  def banksampah_params
    params.permit(:name, :phone, :address, :image, :password, :password_confirmation, :latitude, :longitude)
  end
end
