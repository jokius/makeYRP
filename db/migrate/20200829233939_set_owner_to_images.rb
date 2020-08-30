class SetOwnerToImages < ActiveRecord::Migration[6.0]
  def up
    Image.find_each do |image|
      next image.destroy if image.page.nil?

      image.update(owner_id: image.page.game.master_id)
    end

    change_column_null :images, :owner_id, false
  end

  def down
    change_column_null :images, :owner_id, true
  end
end
