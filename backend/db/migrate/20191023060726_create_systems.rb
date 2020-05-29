class CreateSystems < ActiveRecord::Migration[6.0]
  def change
    create_table :systems do |t|
      t.string :name, null: false
      t.string :key, null: false
      t.string :version, null: false
      t.jsonb :template, default: {}

      t.timestamps
    end
  end
end
