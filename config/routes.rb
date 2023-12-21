require "sidekiq/web"
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"
Rails.application.routes.draw do
  devise_for :outlets
  devise_for :banksampahs
  mount Sidekiq::Web => "/sidekiq"

  get "notify/:uuid", to: "notify#index"
  get "box/status/:uuid", to: "notify#box_status"
  get "box/:uuid", to: "notify#box_index"

  # devise_for :mitras
  # devise_for :admins
  # devise_for :users
  # Defines the root path route ("/")

  root to: "home#index"
  get "version", to: "home#version"

  namespace :api do
    namespace :v1 do
      get 'admin_outlet/create'
      get "jemputan/alamat_jemput"
      scope "callback" do
        post "payment-linkqu", to: "callback#payment_linkqu"
        post "va-user", to: "callback#va_user"
        post "topup", to: "callback#topup"
        post "iak", to: "callback#iak"
      end
      scope "box" do
        get "list", to: "boxes#list"
        get ":uuid", to: "boxes#show"
        post "datatable", to: "boxes#datatable"
        delete "clear/:uuid", to: "boxes#box_clear"        
        post "", to: "boxes#create"
        delete ":uuid", to: "boxes#destroy"
        patch ":uuid", to: "boxes#update"
      end

      scope "botol" do
        post "datatable", to: "botols#datatable"
        post "harga-jual", to: "admin#harga_jual"
        delete ":uuid", to: "botols#destroy"
        patch ":uuid", to: "botols#update"
        get ":uuid/harga", to: "botols#show_harga"
        get "list", to: "botols#botol_list"
        get ":uuid", to: "botols#show"
        post ":uuid/harga", to: "botols#create_harga"
        patch ":uuid/harga", to: "botols#update_harga"
        post "", to: "botols#create"
      end

      scope "user" do
        get "check-botol", to: "users#check_botol"
        get "balance", to: "users#balance"
        get "profile", to: "users#profile"
        post "datatable", to: "users#datatable"
        post "rewards", to: "users#rewards"
        post "update-user/:user_uuid", to: "users#update_user"
        post "forgot-password", to: "users#forgot_password"
        post "reset-password/:token", to: "users#reset_password"
        post "bank-info", to: "users#bank_info_update"
        post "withdraw", to: "users#withdraw"
        post "bank-validation", to: "payment#bank_validation"
        get "news", to: "users#get_rss"
        get "bank-info", to: "users#bank_info"
        get "bank-sampah", to: "users#list_banksampah"
        get "tipe-sampah", to: "users#tipe_sampah"
        post "list-sampah/:banksampah_id", to: "users#list_sampah"
        post "order-sampah/:banksampah_id", to: "users#order_sampah"
        get "order-sampah/:uuid", to: "users#order_read"
        get "order-status/:order_id", to: "users#order_status"
        delete "order-cancel/:order_uuid", to: "users#order_cancel"
        post "va-create", to: "users#va_create_multi"
        get "va-list", to: "users#va_list"
        post "move", to: "user#move_mountpay"
        get "history", to: "history#index"
        get ":uuid", to: "users#show"
        delete ":uuid", to: "users#destroy"
        patch "", to: "users#update_profile"
      end

      scope "merk" do
        get "", to: "merks#index"
        get ":uuid", to: "merks#show"
        post "datatable", to: "merks#datatable"
        post "", to: "merks#create"
        delete ":uuid", to: "merks#destroy"
        patch ":uuid", to: "merks#update"
      end

      scope "images" do
        post "upload/:uuid", to: "transaction#upload"
      end

      scope "transaction" do
        # delete ":uuid", to: "admin#transaction_delete"
        delete "", to: "admin#transaction_delete"
        post "process/:uuid", to: "admin#transaction_process"
        patch ":uuid", to: "transaction#update_botol"
      end

      scope "admin" do
        post "login", to: "admin#login"
        post "forgot", to: "admin#forgot"
        post "change-password", to: "admin#change_password"
        post "datatable", to: "admin#datatable"
        post "transaction", to: "admin#transaction"
        post "withdraw", to: "admin#withdrawl"
        get "withdraw/:id", to: "admin#withdrawl_read"
        patch "withdraw/:id", to: "admin#withdrawl_proses"         
        scope "banksampah" do
          get ":banksampah_uuid", to: "admin#bsi_show"
          post "order-sampah-datatable", to: "admin#order_datatable"
          delete ":uuid", to: "admin#bsi_destroy"
          post "datatable", to: "admin#banksampah_datatable"
          post "tipesampah-datatable", to: "tipe_sampah#tipesampah_datatable"
          post "tipesampah", to: "tipe_sampah#tipesampah_create"
          get "tipesampah/:id", to: "tipe_sampah#tipesampah_show"
          delete "tipesampah/:id", to: "tipe_sampah#tipesampah_destroy"
          patch "tipesampah/:id", to: "tipe_sampah#tipesampah_update"
          post "transfer/:banksampah_uuid", to: "admin#manual_transfer"
          patch "password/:banksampah_uuid", to: "admin#bsi_update_password"
          patch "profile/:banksampah_uuid", to: "admin#bsi_update"
        end
        scope "penjemputan" do
          post "datatable", to: "admin#jemputan_datatable"
          patch "status/:id", to: "jemputan_admin#jemputan_update"          
        end

        scope "outlet" do          
          post "create", to: "admin_outlet#create"
          patch "update/:id", to: "admin_outlet#update"
          delete ":id", to: "admin_outlet#destroy"
          patch "password/:id", to: "admin_outlet#change_password"
          post "datatable", to: "admin_outlet#datatable"          
          post "voucher-datatable", to: "admin_outlet#voucher_datatable"          
          post ":outlet_id/voucher", to: "admin_outlet#voucher_create"
          get "voucher/:id", to: "admin_outlet#voucher_show"
          patch "voucher/:id", to: "admin_outlet#voucher_update_status"
          delete "voucher/:id", to: "admin_outlet#voucher_destroy"
          get ":id", to: "admin_outlet#show"
        end

        post "mitra/bukti/datatable", to: "admin#mitra_bukti_datatable"
        get "mitra/bukti/:id", to: "admin#mitra_bukti_show"
        post "mitra/bukti/proses", to: "admin#mitra_bukti_proses"
        post "mitra/proses/:mitra_id", to: "admin#mitra_proses"
        post "", to: "admin#create"
        get ":uuid", to: "admin#show"
        patch ":uuid", to: "admin#update"
        delete ":uuid", to: "admin#destroy"
      end

      scope "mitra" do
        post "register", to: "mitras#register"
        post "login", to: "mitras#login"
        get "profile", to: "mitras#profile"
        get "mitra-kyc", to: "mitras#mitra_kyc"
        post "create-kyc", to: "mitras#create_kyc"
        get "kyc", to: "mitras#show_self_kyc"
        get "kyc/:uuid", to: "mitras#show_kyc"
        post "datatable", to: "mitras#datatable"
        post "transaction", to: "mitras#transaction"
        get "activation-code/:code", to: "mitras#active_code"
        post "kyc/status/:uuid", to: "mitras#set_status"
        post "profile-update", to: "mitras#update_profile"
        get "active", to: "mitras#mitra_active"
        get "dropbox", to: "mitras#dropbox"
        get "balance", to: "mitras#balance"
        get "bank-info", to: "mitras#bank_info"
        post "bank-info", to: "mitras#bank_info_update"
        post "withdraw", to: "mitras#withdraw"
        post "forgot-password", to: "mitras#forgot_password"
        post "reset-password/:token", to: "mitras#reset_password"
        post "va-create", to: "mitras#va_create_multi"
        get "va-list", to: "mitras#va_list"
        post "", to: "mitras#create"

        get ":uuid", to: "mitras#show"
        scope "box" do
          post "datatable", to: "mitras#box_datatable"
        end

        scope "payment" do
          post "create", to: "mitras_payment#create_payment"
        end
      end

      scope "banksampah" do
        post "register", to: "banksampah#register"
        post "resend", to: "banksampah#resend"
        post "login", to: "banksampah#login"
        post "forgot", to: "banksampah#forgot_password"
        post "datatable", to: "banksampah#datatable"
        post "order_datatable", to: "banksampah#order_datatable"
        get "profile", to: "banksampah#profile"
        get "tipe-sampah", to: "banksampah#tipe_sampah"
        post "sampah", to: "banksampah#sampah_create"
        get "sampah/:uuid", to: "banksampah#sampah_read"
        get "order-sampah/last", to: "banksampah#order_sampah_last"
        get "order-sampah/:uuid", to: "banksampah#order_sampah_read"
        patch "order-sampah/:uuid", to: "banksampah#order_sampah_update"
        patch "sampah/:uuid", to: "banksampah#sampah_update"
        delete "sampah/:uuid", to: "banksampah#sampah_delete"
        post "datatable", to: "banksampah#datatable"
        post "order-sampah-datatable", to: "banksampah#order_datatable"
        patch "order-sampah-proses/:uuid", to: "banksampah#order_sampah_proses"
        post "order-sampah-payment/:uuid", to: "banksampah#order_sampah_payment"
        post "va-create", to: "banksampah#va_create_multi"
        get "va-list", to: "banksampah#va_list"
        get "balance", to: "banksampah#balance"

        scope "inventory" do
          patch "/:tipe_id", to: "banksampah#inventory_update"
          delete "/:tipe_id", to: "banksampah#inventory_delete"
          get "/:tipe_id", to: "banksampah#inventory_read"
          get "", to: "banksampah#inventory_list"
        end
        get ":uuid", to: "banksampah#show"
      end

      scope "jemput" do
        get "alamat-jemput", to: "jemputan#alamat_jemput"
        get "alamat-jemput/:id", to: "jemputan#alamat_jemput_show"        
        delete "alamat-jemput/:id", to: "jemputan#alamat_jemput_delete"
        post "alamat-jemput", to: "jemputan#alamat_jemput_create"
        patch "alamat-jemput/:id", to: "jemputan#alamat_jemput_update"
        get "jam-list", to: "jemputan#jam_list"
        post "penjemputan", to:"jemputan#jemputan_create"
        get "penjemputan/:id", to:"jemputan#jemputan_show"
        delete "penjemputan/:id", to:"jemputan#jemputan_delete"
      end

      # Form KYC
      scope "kyc" do
        get "province", to: "kyc#province"
        get "city/:province_id", to: "kyc#city"
        get "district", to: "kyc#district"
        post "datatable", to: "mitras#mitra_kyc"
        get "total-waiting", to: "kyc#total_waiting"
      end

      scope "payment" do
        get "bank-list", to: "payment#bank_list"
      end

      scope "ppob" do
        post "check-nomor", to: "ppob#check_nomor"
        scope "post" do
          get "price/:type", to: "ppob#post_price"
          post "inquiry", to: "ppob#post_inquiry"
          post "payment", to: "ppob#post_payment"
          post "status", to: "ppob#post_status"
        end

        scope "prepaid" do
          get "price", to: "ppob#prepaid_price"
          post "inquiry", to: "ppob#prepaid_inquiry"
          post "inquiry-pln", to: "ppob#prepaid_inquiry_pln"
          post "inquiry-ovo", to: "ppob#prepaid_inquiry_ovo"
          post "top-up", to: "ppob#prepaid_topup"
          post "status", to: "ppob#prepaid_status" #
        end
      end

      # User webapp
      post "register", to: "users#register"
      get "register/activation-code/:code", to: "users#active_code"
      post "login", to: "users#login"
      post "google-login", to: "users#google_login"
      scope :dropbox do
        get "views/:uuid", to: "users#scan"
        get "insert/:uuid", to: "users#insert"
        post "insert/:uuid", to: "users#insert"
      end

      namespace :partner do
        post "register", to: "partner#register"
        post "login", to: "partner#login"
        get "verify/:uuid", to: "partner#verify"
        post "change-password", to: "partner#change_password"
        get "dashboard", to: "partner#dashboard"
        get "recent", to: "partner#recent"
        scope :admin do
          get "test", to: "admin#home"
        end
      end
      get "settings/:field", to: "setting#info"
    end
  end
  get "banksampah/activation-code/:code", to: "api/v1/banksampah#active_code", as: "active_code"
  mount ActionCable.server => "/cable"
end
