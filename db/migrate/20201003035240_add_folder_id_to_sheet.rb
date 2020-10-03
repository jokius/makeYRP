class AddFolderIdToSheet < ActiveRecord::Migration[6.0]
  def change
    add_column :sheets, :folder_id, :integer
  end
end
