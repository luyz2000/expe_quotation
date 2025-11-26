class CreateQuotationItems < ActiveRecord::Migration[8.0]
  def change
    create_table :quotation_items do |t|
      t.references :quotation, null: false, foreign_key: true
      t.integer :type, default: 0  # Default to material
      t.text :description, null: false
      t.decimal :quantity, precision: 8, scale: 2, default: 0.0
      t.integer :unit, default: 0   # Default to piece
      t.decimal :unit_price, precision: 10, scale: 2, default: 0.0
      t.decimal :amount, precision: 10, scale: 2, default: 0.0
      t.integer :currency, default: 0   # Default to MXN

      t.timestamps
    end
  end
end
