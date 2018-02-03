Rails.application.routes.draw do
	namespace :api do
		namespace :v1 do
			resources :bank do
				resources :bank_accounts, only: [:show, :create]
				resources :payments, only: [:show, :create]
			end
		end
	end
end
