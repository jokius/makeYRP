class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.belongs_to :system, null: false, index: true
      t.belongs_to :master, null: false, index: true
      t.string :name, null: false
      t.boolean :open, null: false, default: true

      t.timestamps
    end
  end
end
