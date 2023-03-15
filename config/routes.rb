Rails.application.routes.draw do  
  get 'notify/index'
  # devise_for :mitras
  # devise_for :admins
  # devise_for :users
  # Defines the root path route ("/")

  root to:'home#index'
  namespace :api do
    namespace :v1 do      
      scope 'box' do        
        get 'list',                to: 'boxes#list'
        get ':uuid',               to: 'boxes#show'
        post 'datatable',          to: 'boxes#datatable'
        post '',                   to: 'boxes#create'
        delete ':uuid',            to: 'boxes#destroy'
        patch ':uuid',             to: 'boxes#update'
      end

      scope 'botol' do        
        post 'datatable',          to: 'botols#datatable'   
        post 'harga-jual',         to: 'admin#harga_jual'     
        delete ':uuid',            to: 'botols#destroy'
        patch ':uuid',             to: 'botols#update'
        get ':uuid/harga',         to: 'botols#show_harga'
        get 'list',                to: 'botols#botol_list'
        get ':uuid',               to: 'botols#show'
        post ':uuid/harga',        to: 'botols#create_harga'
        patch ':uuid/harga',       to: 'botols#update_harga'
        post '',                   to: 'botols#create'
      end

      scope 'user' do
        get 'check-botol',         to: 'users#check_botol'
        get 'balance',             to: 'users#balance'
        get 'profile',             to: 'users#profile'
        post 'datatable',          to: 'users#datatable'
        post 'rewards',            to: 'users#rewards'
        post 'update-user/:user_uuid', to: 'users#update_user'        
        post 'forgot-password',    to: 'users#forgot_password'
        post 'reset-password/:token', to: 'users#reset_password'
        get ':uuid',               to: 'users#show'
        delete ':uuid',            to: 'users#destroy'
        patch '',                  to: 'users#update_profile'
      end

      scope 'merk' do
        get '',                    to: 'merks#index'
        get ':uuid',               to: 'merks#show'
        post 'datatable',          to: 'merks#datatable'
        post '',                   to: 'merks#create'
        delete ':uuid',            to: 'merks#destroy'
        patch ':uuid',             to: 'merks#update'
      end

      scope 'images' do
        post 'upload/:uuid',       to: 'transaction#upload'
      end

      scope 'admin' do        
        post 'login',              to: 'admin#login'
        post 'forgot',             to: 'admin#forgot'
        post 'change-password',    to: 'admin#change_password'
        post 'datatable',          to: 'admin#datatable'
        post 'transaction',        to: 'admin#transaction'        
        post '',                   to: 'admin#create'
        get ':uuid',               to: 'admin#show'
        patch ':uuid',             to: 'admin#update'
        delete ':uuid',            to: 'admin#destroy'
      end

      scope 'mitra' do
        post 'register',             to: 'mitras#register'
        post 'login',                to: 'mitras#login'
        get 'profile',               to: 'mitras#profile'
        get 'mitra-kyc',             to: 'mitras#mitra_kyc'
        post 'create-kyc',           to: 'mitras#create_kyc'        
        get 'kyc',                   to: 'mitras#show_self_kyc'
        get 'kyc/:uuid',             to: 'mitras#show_kyc'
        post 'datatable',            to: 'mitras#datatable'
        post 'transaction',          to: 'mitras#transaction'
        get 'activation-code/:code', to: 'mitras#active_code'
        post 'kyc/status/:uuid',     to: 'mitras#set_status'
        post 'profile-update',       to: 'mitras#update_profile'
        get 'active',                to: 'mitras#mitra_active'
        get 'dropbox',               to: 'mitras#dropbox'        
        get 'balance',               to: 'mitras#balance'
        post 'forgot-password',      to: 'mitras#forgot_password'
        post 'reset-password/:token', to: 'mitras#reset_password'
        post '',                     to: 'mitras#create'

        get ':uuid',                 to: 'mitras#show'
        scope 'box' do
          post 'datatable',          to: 'mitras#box_datatable'
        end        
        # delete ':uuid',            to: 'mitras#destroy'
        # patch ':uuid',             to: 'mitras#update'
      end

      # Form KYC
      scope 'kyc' do
        get 'province',                to: 'kyc#province'
        get 'city/:province_id',       to: 'kyc#city'
        get 'district',                to: 'kyc#district'  
        post 'datatable',              to: 'mitras#mitra_kyc'   
        get 'total-waiting',           to: 'kyc#total_waiting'
      end

      # User webapp
      post 'register',                        to: 'users#register'
      get  'register/activation-code/:code',  to: 'users#active_code'
      post 'login',                           to: 'users#login'      
      scope :dropbox do
        get 'views/:uuid',                    to: 'users#scan'
        post 'insert/:uuid',                  to: 'users#insert'        
      end     
    end
  end
  mount ActionCable.server => '/cable'
end
