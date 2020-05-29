class CreateTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :tokens do |t|
      t.belongs_to :page, index: true, null: false
      t.belongs_to :sheet, index: true, null: false
      t.float :position_x, null: false
      t.float :position_y, null: false

      t.timestamps
    end
  end
end
