class CreateServices < ActiveRecord::Migration[8.0]
  def change
    create_table :services do |t|
      t.string :code, null: false
      t.string :title, null: false
      t.text :description
      t.integer :unit, default: 0  # Default to hour
      t.decimal :suggested_price, precision: 10, scale: 2, default: 0.0
      t.decimal :public_price, precision: 10, scale: 2, default: 0.0
      t.integer :category, default: 0  # Default to installation

      t.timestamps
    end
  end
end
