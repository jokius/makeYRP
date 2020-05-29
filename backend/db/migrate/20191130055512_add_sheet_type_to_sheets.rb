class AddSheetTypeToSheets < ActiveRecord::Migration[6.0]
  def change
    add_column :sheets, :sheet_type, :string, null: false
  end
end
