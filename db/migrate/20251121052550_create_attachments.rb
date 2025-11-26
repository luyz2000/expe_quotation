class CreateAttachments < ActiveRecord::Migration[8.0]
  def change
    create_table :attachments do |t|
      t.string :file
      t.string :attachable_type
      t.integer :attachable_id
      t.integer :file_size
      t.string :file_type
      t.string :original_filename
      t.string :file_description

      t.timestamps
    end

    add_index :attachments, [:attachable_type, :attachable_id]
  end
end
