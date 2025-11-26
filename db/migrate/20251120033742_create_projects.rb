class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :folio_number, null: false
      t.string :name, null: false
      t.text :description
      t.references :client, null: false, foreign_key: true
      t.references :responsible, null: false, foreign_key: true
      t.text :location
      t.integer :project_type, default: 0  # Default to construccion
      t.integer :status, default: 0       # Default to planificado
      t.date :start_date
      t.date :estimated_end_date
      t.date :actual_end_date

      t.timestamps
    end
  end
end
