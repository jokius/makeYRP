class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.belongs_to :game, index: true, null: false
      t.boolean :by_system, default: false, null: false
      t.string :item_type, null: false
      t.string :name, null: false
      t.jsonb :params, default: {}, null: false

      t.timestamps
    end
  end
end
