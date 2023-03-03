Rails.application.routes.draw do  
  devise_for :mitras
  devise_for :admins
  devise_for :users
  # Defines the root path route ("/")

  root to:'home#index'
  namespace :api do
    namespace :v1 do      
      scope 'box' do
        get '',                    to: 'boxes#index'
        get ':uuid',               to: 'boxes#show'
        post 'datatable',          to: 'boxes#datatable'
        post '',                   to: 'boxes#create'
        delete ':uuid',            to: 'boxes#destroy'
        patch ':uuid',             to: 'boxes#update'
      end

      scope 'botol' do
        get '',                    to: 'botols#index'
        get ':uuid',               to: 'botols#show'
        post 'datatable',          to: 'botols#datatable'
        post '',                   to: 'botols#create'
        delete ':uuid',            to: 'botols#destroy'
        patch ':uuid',             to: 'botols#update'
      end

      scope 'user' do
        get '',                    to: 'users#index'
        get ':uuid',               to: 'users#show'
        post 'datatable',          to: 'users#datatable'
        post '',                   to: 'users#create'        
        post 'change-password',    to: 'users#change_password'
        delete ':uuid',            to: 'users#destroy'
        patch ':uuid',             to: 'users#update'
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
      end

      scope 'mitra' do
        post 'register',             to: 'mitras#register'
        post 'login',                to: 'mitras#login'
        get '',                      to: 'mitras#index'
        get ':uuid',                 to: 'mitras#show'
        get 'kyc/:uuid',             to: 'mitras#show_kyc'
        post 'datatable',            to: 'mitras#datatable'
        post '',                     to: 'mitras#create'
        get 'activation-code/:code', to: 'mitras#active_code'
        post 'create-kyc',           to: 'mitras#create_kyc'
        post 'kyc/status/:uuid',     to: 'mitras#set_status'
        # delete ':uuid',            to: 'mitras#destroy'
        # patch ':uuid',             to: 'mitras#update'
      end

      # Form KYC
      scope 'kyc' do
        get 'province',                to: 'kyc#province'
        get 'city/:province_id',       to: 'kyc#city'
        get 'district',                to: 'kyc#district'
      end

      # User webapp
      post 'register',                        to: 'users#register'
      get  'register/activation-code/:code',  to: 'users#active_code'
      post 'login',                           to: 'users#login'      

    end
  end
  
end
