Rails.application.routes.draw do
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
    end
  end
  
end
