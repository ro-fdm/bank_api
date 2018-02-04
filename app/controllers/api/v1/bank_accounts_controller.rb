module Api::V1
	class BankAccountsController < ApplicationController
		def create
			@bank_account = current_user.bank_accounts.create(bank_account_params)
			@bank_account.bank = Bank.find(params[:bank_id])
			@bank_account.save!
			json_response(@bank_account, :created)
		end

		def show
			@bank_account = current_user.bank_accounts.find(params[:id])
			json_response(@bank_account)
		end

		def payments
			bank_account = current_user.bank_accounts.find(params[:bank_account_id])	
			@payments	= bank_account.origin_payments
			json_response(@payments)
		end

		private

		def bank_account_params
			params.require(:bank_account).permit(:iban, :balance)
		end
	end
end
