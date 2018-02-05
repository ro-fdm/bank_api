class BankAccount < ApplicationRecord
  belongs_to :bank
  belongs_to :user
  validates_presence_of :balance
  validates_presence_of :iban
  validates_numericality_of :balance, only_integer: true, greater_than: 0
  has_many :origin_payments, class_name: 'Payment', foreign_key: 'origin_id'
  has_many :destination_payments, class_name: 'Payment', foreign_key: 'destination_id'
end
