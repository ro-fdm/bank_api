class Transfer

	def initialize(payment)
		@payment = payment
	end

	def run!
		ActiveRecord::Base.transaction do
			if @payment.origin.bank == @payment.destination.bank
				intra_bank
			else
				limit_inter_bank
				inter_bank
			end
			update_balances

		end
	end

	def intra_bank
		@payment.comision = 0
		@payment.status = "OK"
		@payment.save!
	end

	def inter_bank
		@payment.comision = 500
		@payment.status = "OK"
		@payment.save!
	end

	def limit_inter_bank
		if @payment.amount > 100000
			raise ActiveRecord::Rollback
		end
	end

	def update_balances
		origin = @payment.origin
		origin.balance = origin.balance - @payment.amount - @payment.comision
		origin.save!

		destination = @payment.destination
		destination.balance = destination.balance + @payment.amount
		destination.save!
	end

end