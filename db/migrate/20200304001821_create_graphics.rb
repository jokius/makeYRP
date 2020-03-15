class CreateGraphics < ActiveRecord::Migration[6.0]
  def change
    create_table :graphics do |t|
      t.belongs_to :page, index: true, null: false
      t.string :layer, index: true
      t.jsonb :params

      t.timestamps
    end
  end
end
