module Api::V1
	class BankAccountsController < ApplicationController
		before_action :set_bank

		def create
			@bank_account = @bank.bank_accounts.create!(bank_account_params)
			json_response(@bank_account, :created)
		end

		def show
			@bank_account = @bank.bank_accounts.find(params[:id])
			json_response(@bank_account)
		end

		private

		def bank_account_params
			params.require(:bank_account).permit(:iban, :balance)
		end

		def set_bank
			@bank = Bank.find(params[:bank_id])
		end
	end
end
