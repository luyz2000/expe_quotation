class CreateQuotations < ActiveRecord::Migration[8.0]
  def change
    create_table :quotations do |t|
      t.string :quotation_number, null: false
      t.references :project, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.references :salesperson, null: false, foreign_key: true  # salesperson will reference users table
      t.integer :project_type, default: 0  # Default to media_tension
      t.date :publish_date
      t.date :expiry_date
      t.decimal :subtotal, precision: 10, scale: 2, default: 0.0
      t.decimal :total, precision: 10, scale: 2, default: 0.0
      t.integer :status, default: 0      # Default to borrador
      t.text :terms_conditions
      t.text :notes
      t.integer :revision_number, default: 0

      t.timestamps
    end
  end
end
