class AddKindToPayments < ActiveRecord::Migration[5.1]
  def change
  	add_column :payments, :kind, :string
  end
end
