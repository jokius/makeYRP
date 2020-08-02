class CreateMedia < ActiveRecord::Migration[6.0]
  def change
    create_table :media do |t|
      t.string :key, null: false

      t.timestamps
    end
  end
end
