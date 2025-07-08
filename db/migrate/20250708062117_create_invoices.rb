class CreateInvoices < ActiveRecord::Migration[7.2]
  def change
    create_table :invoices do |t|
      t.string :invoice_number, null: false, index: { unique: true }
      t.decimal :total, precision: 10, scale: 2, default: 0.0, null: false
      t.string :status, default: "pending", null: false
      t.date :invoice_date, null: false
      t.string :customer_name

      t.timestamps
    end
    
    add_index :invoices, :invoice_date
    add_index :invoices, :status
  end
end
