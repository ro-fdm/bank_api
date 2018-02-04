class Payment < ApplicationRecord
	belongs_to :origin, :class_name => "BankAccount"
	belongs_to :destination, :class_name => "BankAccount"
	validates_presence_of :amount

	validates :kind, inclusion: { in: %w(transfer) }
end
