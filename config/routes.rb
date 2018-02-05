Rails.application.routes.draw do
  post 'auth/login', to: 'authentication#authenticate'

  post 'signup', to: 'users#create'

  namespace :api do
    namespace :v1 do
      resources :banks, only: %i[index create] do
        get 'payments'

        resources :bank_accounts, only: [:create] do
          get 'payments'
        end
      end
      resources :bank_accounts, only: [:show]
      resources :payments, only: %i[show create]
    end
  end
end
