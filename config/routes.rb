Rails.application.routes.draw do

	post 'auth/login', to: 'authentication#authenticate'

	post 'signup', to: 'users#create'

	namespace :api do
		namespace :v1 do
			resources :banks, only: [:index, :create] do
				get "payments"

				resources :bank_accounts, only: [:show, :create] do
					get "payments"
				end
				resources :payments, only: [:show, :create]
			end
		end
	end
end
