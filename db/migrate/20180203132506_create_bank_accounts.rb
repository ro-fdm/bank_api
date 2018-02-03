class CreateBankAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :bank_accounts do |t|
      t.string :iban
      t.integer :balance
      t.references :bank, foreign_key: true

      t.timestamps
    end
  end
end
