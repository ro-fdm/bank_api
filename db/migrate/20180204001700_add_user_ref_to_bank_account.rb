class AddUserRefToBankAccount < ActiveRecord::Migration[5.1]
  def change
  	add_reference :bank_accounts, :user, foreign_key: true
  end
end
