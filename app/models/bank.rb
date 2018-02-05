class Bank < ApplicationRecord
  validates_presence_of :name
  has_many :bank_accounts
end
