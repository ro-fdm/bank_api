class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.integer :amount
      t.string :status
      t.references :origin, index: true
      t.references :destination, index: true
      t.integer :comision

      t.timestamps
    end
  end
end
