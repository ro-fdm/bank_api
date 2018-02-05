class User < ApplicationRecord
  has_secure_password

  has_many :bank_accounts
  validates_presence_of :name, :email, :password_digest
end
