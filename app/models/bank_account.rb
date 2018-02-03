class BankAccount < ApplicationRecord
  belongs_to :bank
  validates_presence_of :balance
  validates_presence_of :iban
end
