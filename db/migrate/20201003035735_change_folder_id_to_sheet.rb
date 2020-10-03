class ChangeFolderIdToSheet < ActiveRecord::Migration[6.0]
  def change
    change_column_null :sheets, :folder_id, false
  end
end
