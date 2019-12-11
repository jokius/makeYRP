class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.belongs_to :game, index: true, null: false
      t.belongs_to :user, null: false
      t.belongs_to :whisper_to
      t.jsonb :body

      t.timestamps
    end
  end
end
