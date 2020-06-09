class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.belongs_to :page, index: true, null: false
      t.jsonb :params, null: false

      t.timestamps
    end
  end
end
