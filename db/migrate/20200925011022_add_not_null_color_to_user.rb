class AddNotNullColorToUser < ActiveRecord::Migration[6.0]
  def up
    User.find_each do |user|
      user.create_color
      user.save
    end

    change_column_null :users, :color, false
  end

  def down
    change_column_null :users, :color, true
  end
end
