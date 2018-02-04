class Payment < ApplicationRecord
	belongs_to :origin, :class_name => "BankAccount"
	belongs_to :destination, :class_name => "BankAccount"
	validates_presence_of :amount
	validates_numericality_of :amount, only_integer: true, greater_than: 0

	validates :kind, inclusion: { in: %w(transfer) }, :allow_nil => true

	def payment_service
		self.kind.capitalize.constantize
	end
end
