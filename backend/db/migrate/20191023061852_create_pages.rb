class CreatePages < ActiveRecord::Migration[6.0]
  def change
    create_table :pages do |t|
      t.belongs_to :game, null: false, index: true
      t.string :name, null: false
      t.jsonb :params, null: false, default: {}

      t.timestamps
    end
  end
end
