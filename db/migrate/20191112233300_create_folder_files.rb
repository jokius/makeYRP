class CreateFolderFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :folder_files do |t|
      t.belongs_to :folder, index: true, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
