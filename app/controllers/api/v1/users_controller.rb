require "feedjira"

class Api::V1::UsersController < AdminController
  include ActiveStorage::SetCurrent

  before_action :check_admin_token, only: [
                                      :show,
                                      :datatable,
                                      :destroy,
                                      :update_user,
                                    ]

  before_action :check_user_token, only: [
                                     :scan,
                                     :check_botol,
                                     :balance,
                                     :profile,
                                     :update_profile,
                                     :rewards,
                                     :rss,
                                     :bank_info,
                                     :bank_info_update,
                                     :withdraw,
                                     :va_create,
                                     :va_list,
                                     :va_create_multi,
                                     :list_banksampah,
                                     :tipe_sampah,
                                     :order_sampah,
                                     :order_status,
                                     :order_cancel,
                                     :list_sampah,
                                     :order_read,
                                   ]

  @@fee = ENV["linkqu_fee"].to_f
  @@url = ENV["linkqu_url"]
  @@username = ENV["linkqu_username"]
  @@pin = ENV["linkqu_pin"]
  @@bank_code = "002" # 002 = Bank BRI
  @@fee_sampah = 2.5 # In percentage
  HOLD_WITHDRAW = false

  if Rails.env.production?
    MIN_WITHDRAW = 50000
    @@token_expired = 30.days.to_i
  else
    MIN_WITHDRAW = 10000
    @@token_expired = 30.days.to_i
  end

  def index
    render json: User.all
  end

  def show
    user = User.find_by(uuid: params[:uuid])
    if user
      render json: user
    else
      render json: { message: "Not found" }, status: :not_found
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
    user.active = true
    user.password = params[:password]
    user.password_confirmation = params[:password_confirmation]
    begin
      headers = request.headers
      jwt = headers["Authorization"].split(" ").last
      partner = Partner.get_jwt(jwt)
      user.partner_id = partner.id
    rescue
      # Do nothing
    end
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
      render json: { message: "Not found" }, status: :not_found
    end
  end

  def login
    if user = User.find_by(email: params[:email], active: true)
      if user.valid_password?(params[:password])
        payload = {
          user_uuid: user.uuid,
          exp: Time.now.to_i + @@token_expired,
        }
        token = JWT.encode payload, ENV["secret_key_base"], ENV["token_algorithm"]
        render json: { token: token, email: user.email, username: user.username, uuid: user.uuid, id: user.id }
      else
        render json: { message: "Not found" }, status: :unauthorized
      end
    else
      render json: { message: "Not found" }, status: :unauthorized
    end
  end

  def google_login
    if params[:email] && params[:google_id]
      user = User.find_by(email: params[:email], google_id: params[:google_id])
      if !user
        user = User.new()
        user.username = params[:name]
        user.email = params[:email]
        user.active = true
        user.google_id = params[:google_id]
        user.username = params[:name] || "Noname"
        user.active_code = nil
        user.password = "blank password"
        user.save!
      end
      if user.active == false
        render json: { message: "Your account is not active" }, status: :unauthorized
      else
        payload = {
          user_uuid: user.uuid,
          exp: Time.now.to_i + @@token_expired,
        }
        token = JWT.encode payload, ENV["secret_key_base"], ENV["token_algorithm"]
        render json: { token: token, email: user.email, username: user.username, uuid: user.uuid, id: user.id }
      end
    else
      render json: { message: "Not found" }, status: :unauthorized
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
      # user.username = params[:username]
      # user.email = params[:email]
      user.active = params[:active]
      user.save
      render json: user
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  def update_user # Used by admin
    user = User.find_by(uuid: params[:user_uuid])
    if user
      user.username = params[:username] if params[:username]
      user.email = params[:email] if params[:email]
      user.phone = params[:phone] if params[:phone]
      user.active = params[:active] if params[:active]
      user.reset_password(params[:password], params[:password_confirmation]) if params[:password]
      if user.save
        render json: UserBlueprint.render(user, view: :register)
      else
        render json: user.errors
      end
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  def destroy
    if user = User.find_by(uuid: params[:uuid])
      user.delete
      render json: { message: "Deleted" }
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  def scan
    Box.where(user: @current_user).update(user_id: nil)
    box = Box.find_by(uuid: params[:uuid], type_progress: "active")
    if box
      box.update!(user_id: @current_user.id)
      render json: BoxBlueprint.render(box)
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  def insert
    box = Box.find_by(uuid: params[:uuid], type_progress: "active")
    if box
      harga_botol = box.price_pcs || 65 # Nanti disesuaikan sesuai botol yang masuk
      mitra_amount = box.mitra_share * harga_botol / 100
      user_amount = box.user_share * harga_botol / 100
      transaction = Transaction.new()
      transaction.mitra = box.mitra
      transaction.user = box.user
      transaction.box_id = box.id
      transaction.harga = harga_botol
      # transaction.diterima = true # Harus dimaintain jika botol valid atau tidak
      transaction.mitra_amount = mitra_amount
      transaction.user_amount = user_amount
      transaction.gambar = params[:foto]
      # image = params[:foto]
      # if image.present?
      #   result = transaction.foto.attach(io: image.tempfile, filename: image.original_filename)
      #   transaction.set_foto_folder("transaction")
      #   # transaction.foto.attach(image)
      # end
      if transaction.save
        render json: { message: "Checking...", foto: transaction.gambar.url }
      else
        render json: transaction.errors
      end
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  def check_botol
    transaction = Transaction.where(user_id: @current_user.id).order(created_at: :desc).limit(1)
    render json: TransactionBlueprint.render(transaction, view: :check_botol)
  end

  def balance
    user = User.find(@current_user.id)
    render json: { balance: user.usertransactions.balance, mountpay: user.mountpay.balance }
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
      user.reset_password(params[:password], params[:password_confirmation]) if params[:password]
      if user.save
        render json: { message: "Success" }
      else
        render json: user.errors
      end
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  def forgot_password
    if user = User.find_by(email: params[:email])
      raw, enc = Devise.token_generator.generate(User, :reset_password_token)
      user.update(reset_password_token: enc, reset_password_sent_at: Time.now())
      render json: { message: "Success", token: enc }
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  def reset_password
    if user = User.find_by(reset_password_token: params[:token])
      if user.reset_password(params[:new_password], params[:password_confirmation])
        render json: { message: "Success" }
      else
        render json: { error: mitra.errors }
      end
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  def get_image_url(entry)
    if entry.respond_to?(:enclosure) && entry.enclosure
      return entry.enclosure.url
    elsif entry.respond_to?(:image) && entry.image
      return entry.image
    elsif entry.respond_to?(:itunes_image) && entry.itunes_image
      return entry.itunes_image
    end

    return nil
  end

  def get_rss
    require "rss"
    cache_name = "Rss-news"
    arr_items = Rails.cache.fetch(cache_name, expires_in: 5.hours) do
      temp_items = []
      url = "https://news.mountrash.com/feed/"
      URI.open(url) do |rss|
        feed = RSS::Parser.parse(rss)
        feed.items.each do |item|
          page = MetaInspector.new(item.link)
          data = {
            title: item.title,
            link: item.link,
            description: item.description,
            image: page.images.best,
          }
          temp_items.push(data)
        end
      end
      temp_items
    end
    if !arr_items
      Rails.cache.delete(cache_name)
    end
    render json: arr_items
  end

  def bank_info
    user_bank = UserBank.find_by(user_id: @current_user.id)
    if user_bank
      render json: {
        nama: user_bank.nama,
        nama_bank: user_bank.nama_bank,
        rekening: user_bank.rekening,
        kodeBank: user_bank.kodeBank,
        is_valid: user_bank.is_valid,
      }
    else
      render json: { #
        message: "Empty",
      }
    end
  end

  def bank_info_update
    userbank = UserBank.find_by(user_id: @current_user.id)
    bank_validation = User.validate_bank(params[:kodeBank], params[:rekening], params[:nama]&.upcase)
    if userbank
      userbank.nama = params[:nama]
      userbank.nama_bank = params[:nama_bank]
      userbank.rekening = params[:rekening]
      userbank.kodeBank = params[:kodeBank]
      userbank.is_valid = bank_validation
      if userbank.save
        render json: userbank
      else
        render json: { error: userbank.errors }
      end
    else
      if userbank = UserBank.create!(
        user_id: @current_user.id,
        nama: params[:nama],
        nama_bank: params[:nama_bank],
        rekening: params[:rekening],
        kodeBank: params[:kodeBank],
        is_valid: bank_validation,
      )
        render json: userbank
      else
        render json: { error: userbank.errors }
      end
    end
  end

  def withdraw
    user = User.find(@current_user.id)
    balance = user.usertransactions.balance
    total = params[:amount].to_f + @@fee
    if !HOLD_WITHDRAW
      if user.user_bank&.is_valid?
        if total < balance
          if total >= MIN_WITHDRAW
            Withdrawl.transaction do
              User.find(@current_user.id).debitkan(@@fee, "Withdraw Fee")
              trx = User.find(@current_user.id).debitkan(params[:amount].to_f, "Withdraw")

              process = Withdrawl.new()
              process.amount = params[:amount]
              process.kodeBank = user.user_bank.kodeBank
              process.nama = user.user_bank.nama
              process.rekening = user.user_bank.rekening
              process.user = @current_user
              process.usertransaction_id = trx.id
              if process.save
                desc = "Ke #{user.user_bank.nama_bank} - #{user.user_bank.rekening}"
                User.find(@current_user.id).history_tambahkan(params[:amount].to_f, "Withdraw", desc)
                render json: { message: "You withdraw is waiting approval" }
              else
                render json: { error: process.errors }, status: :bad_request
                raise ActiveRecord::Rollback
              end
            end
          else
            render json: { message: "Minimum withdraw is #{MIN_WITHDRAW}" }, status: :bad_request
          end
        else
          render json: { message: "Insuffient Balance" }, status: :bad_request
        end
      else
        render json: { message: "Invalid user bank info. Please update correct bank information" }, status: :bad_request
      end
    else
      render json: { message: "Sorry, withdraw system is on HOLD. Please contact admin" }, status: :bad_request
    end
  end

  #   {
  #     "time": 10,
  #     "expired": "",
  #     "bank_code": "014",
  #     "bank_name": "",
  #     "customer_phone": "08111111111",
  #     "customer_id": "va|user|601f1517-dc9e-44f4-9b7b-ea8b1f6eb2b2|69910",
  #     "customer_name": "Arie Ardiansyah",
  #     "customer_email": "user3@gmail.com",
  #     "partner_reff": "",
  #     "username": "LI662GDBL",
  #     "pin": "------",
  #     "status": "FAILED",
  #     "response_code": "99",
  #     "response_desc": "Produk Maintenance",
  #     "virtual_account": "",
  #     "partner_reff2": "",
  #     "url_helper": "",
  #     "reserved": false,
  #     "signature": ""
  # }

  def va_create_multi
    if params[:bank_code]
      userva = UserVa.select(:bank_name, :kodeBank, :rekening, :name).find_by(user_id: @current_user.id, kodeBank: params[:bank_code])
      if userva
        render json: { virtual_account: userva.rekening, status: "SUCCESS", customer_name: userva.name, response_desc: "Virtual Account Successfully Created" }
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
        response = conn.post("/linkqu-partner/transaction/create/vadedicated/add") do |req|
          req.body = {
            username: @@username,
            pin: @@pin,
            bank_code: @@bank_code,
            customer_id: "va|user|" + @current_user.uuid + "|" + rand(10000..99999).to_s,
            customer_name: @current_user.username,
            customer_phone: @current_user.phone,
            customer_email: @current_user.email,
            signature: Banksampah.signature("POST", "/linkqu-partner/transaction/create/vadedicated/add"),
          }.to_json
          req.options.timeout = 3
          puts req.body
          # rescue => e
          #   logger.fatal "=== VA create failed ==="
        end
        result = JSON.parse(response.body)
        if !result["virtual_account"].empty?
          hasil = UserVa.create!(
            user_id: @current_user.id,
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

  def va_create_single
    userva = UserVa.select(:bank_name, :kodeBank, :rekening, :name).find_by(user_id: @current_user.id, kodeBank: @@bank_code)
    if userva
      render json: userva
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
      response = conn.post("/linkqu-partner/transaction/create/vadedicated/add") do |req|
        req.body = {
          username: @@username,
          pin: @@pin,
          bank_code: @@bank_code,
          customer_id: "va|user|" + @current_user.uuid + "|" + rand(10000..99999).to_s,
          customer_name: @current_user.username,
          customer_phone: @current_user.phone,
          customer_email: @current_user.email,
        }.to_json
        req.options.timeout = 3
      end
      result = JSON.parse(response.body)
      hasil = UserVa.create!(
        user_id: @current_user.id,
        kodeBank: @@bank_code,
        name: result["customer_name"],
        rekening: result["virtual_account"],
        fee: result["feeadmin"],
        bank_name: result["bank_name"],
      )
      render json: { bank_name: hasil.bank_name, kodeBank: hasil.kodeBank, name: hasil.name, rekening: hasil.rekening }
    end
  end

  def va_list
    render json: UserVa.select(:bank_name, :rekening, :kodeBank, :name).where(user_id: @current_user.id).last
  end

  def list_banksampah
    banks = Banksampah.order(name: :asc)
    render json: BankSampahBlueprint.render(banks)
  end

  def tipe_sampah
    tipes = TipeSampah.order(name: :asc)
    orderan = OrderSampah.where(user_id: @current_user.id, status: "requested").last
    total = orderan != nil ? orderan.total : 0
    render json: { total: total, data: TipeSampahBlueprint.render_as_json(tipes) }
  end

  def list_sampah
    if params[:banksampah_id]
      sampah = Sampah.where(banksampah_id: params[:banksampah_id], active: true).order(name: :asc)
      orderan = OrderSampah.where(user_id: @current_user.id, status: "requested").last
      total = orderan != nil ? orderan.total : 0
      if params[:tipe_sampah_id]
        sampah = sampah.where(tipe_sampah_id: params[:tipe_sampah_id])
      end
      render json: { total: total, data: sampah }
    else
      render json: { message: "Bank sampah required" }, status: :bad_request
    end
  end

  def order_sampah
    if banksampah = Banksampah.find_by(id: params[:banksampah_id]) && params[:banksampah_id]
      total = 0
      if items = params[:_json]
        begin
          ActiveRecord::Base.transaction do
            orderan = OrderSampah.new()
            orderan.fee = @@fee_sampah
            orderan.banksampah_id = params[:banksampah_id]
            orderan.user_id = @current_user.id
            if orderan.save
              items.each do |item|
                if item["sampah_id"] && item["qty"]
                  # harga = HargaSampah.find_by(banksampah_id: params[:banksampah_id], tipe_sampah_id: item["tipe_sampah_id"])
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
            end
            fee_sampah = @@fee_sampah / 100 * total
            orderan.sub_total = total
            orderan.total = fee_sampah + total
            orderan.save

            render json: { order: orderan, items: OrderDetailBlueprint.render_as_json(orderan.order_details) }
          end
        rescue => e
          render json: { hidden_message: e, message: "Some error in your parameter." }, status: :bad_request
        end
      else
        render json: { message: "At least one order item" }, status: :bad_request
      end
    else
      render json: { message: "Parameter not complete or Record not found" }, status: :bad_request
    end
  end

  def order_status
    if orderan = OrderSampah.find_by(uuid: params[:order_id], user_id: @current_user.id)
      render json: { order: orderan }
    else
      render json: { message: "Record not found" }, status: :bad_request
    end
  end

  def order_cancel
    if orderan = OrderSampah.find_by(uuid: params[:order_uuid], user_id: @current_user.id)
      orderan.destroy
      render json: { order: orderan }
    else
      render json: { message: "Record not found" }, status: :bad_request
    end
  end

  def order_read
    if orderan = OrderSampah.find_by(uuid: params[:uuid], user_id: @current_user.id)
      render json: { order: orderan, items: OrderDetailBlueprint.render_as_json(orderan.order_details) }
    else
      render json: { message: "Record not found" }, status: :bad_request
    end
  end

  private
end
