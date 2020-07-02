class CreateCustomSystems < ActiveRecord::Migration[6.0]
  def up
    create_table :custom_systems do |t|
      t.belongs_to :game, index: true, null: false
      t.jsonb :template, default: {}, null: false

      t.timestamps
    end

    Game.all.find_each(&:create_custom_system)
  end

  def down
    drop_table :custom_systems
  end
end
