class CreateAccessLevels < ActiveRecord::Migration[6.0]
  def change
    create_table :access_levels do |t|
      t.belongs_to :object, polymorphic: true, index: true, null: false
      t.belongs_to :user, index: true, null: false
      t.boolean :write, default: false, null: false
      t.boolean :read, default: false, null: false

      t.timestamps
    end
  end
end
