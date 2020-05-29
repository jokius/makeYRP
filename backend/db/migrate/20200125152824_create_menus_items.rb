class CreateMenusItems < ActiveRecord::Migration[6.0]
  def change
    create_table :menus_items do |t|
      t.belongs_to :menu, null: false, index: true
      t.jsonb :params, null: false, default: {}

      t.timestamps
    end
  end
end
