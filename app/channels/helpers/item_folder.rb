# frozen_string_literal: true

class Helpers::ItemFolder < Helpers::Base
  def add(data)
    responds(Menus::Folders::Create, params.merge(data).merge(owner_id: current_user.id)) do |folder|
      broadcast(new: true, item_folder: folder_serializer(folder))
    end
  end

  def change(data)
    return broadcast(errors: 'No permission') unless allowed_to?(:write?, by_data(data))

    responds(Menus::Folders::Update, params.merge(data)) do |folder|
      broadcast(update: true, item_folder: folder_serializer(folder))
    end
  end

  def remove(data)
    folder = by_data(data)
    return broadcast(errors: 'menu folder not found') if folder.nil?
    return broadcast(errors: 'No permission') unless allowed_to?(:remove?, folder)

    folder.destroy unless folder.root?
    broadcast(delete: true, item_folder: true, id: folder.id, menuId: folder.menu_id)
  end

  private

  def by_data(data)
    Menus::ItemFolder.find_by(id: data['id'])
  end

  def folder_serializer(item)
    Menus::FolderSerializer.new(item)
  end
end
