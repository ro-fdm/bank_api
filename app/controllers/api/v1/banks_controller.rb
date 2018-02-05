module Api::V1
	class BanksController < ApplicationController
		def index
			@banks = Bank.all
			json_response(@banks)
		end

		def create
			@bank = Bank.create!(bank_params)
			json_response(@bank, :created)
		end

		def payments
			bank = Bank.find(params[:bank_id])
			bank_payments = Payment.select{ |p| p.origin.bank == bank || p.destination.bank == bank }
			bank_payments_sort = bank_payments.sort_by{ |bp| bp.created_at }.reverse!
			json_response(bank_payments_sort)
		end

		private

		def bank_params
			params.require(:bank).permit(:name)
		end
	end
end
