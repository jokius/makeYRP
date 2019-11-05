class CreateSheets < ActiveRecord::Migration[6.0]
  def change
    create_table :sheets do |t|
      t.belongs_to :game, null: false, index: true
      t.belongs_to :owner, null: false, index: true
      t.boolean :read_all, null: false, default: false
      t.boolean :write_all, null: false, default: false
      t.string :name, null: false
      t.jsonb :params, null: false, default: {}

      t.timestamps

      t.index %i[game_id owner_id]
    end
  end
end
