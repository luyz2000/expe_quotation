class CreateClients < ActiveRecord::Migration[8.0]
  def change
    create_table :clients do |t|
      t.string :company_name, null: false
      t.string :tax_id
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone
      t.text :address
      t.string :city
      t.string :state
      t.integer :client_type, default: 0  # Default to residencial

      t.timestamps
    end
  end
end
