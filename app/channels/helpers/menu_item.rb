# frozen_string_literal: true

class Helpers::MenuItem < Helpers::Base
  def add(data)
    responds(Menus::Items::Create, params.merge(data).merge(owner_id: current_user.id)) do |item|
      broadcast(new: true, menu_item: item_serializer(item))
    end
  end

  def change(data)
    return broadcast(errors: 'No permission') unless allowed_to?(:write?, by_data(data))

    responds(Menus::Items::Update, params.merge(data)) do |menu_item|
      broadcast(update: true, menu_item: item_serializer(menu_item))
    end
  end

  def remove(data)
    menu_item = by_data(data)
    return broadcast(errors: 'menu item not found') if menu_item.nil?
    return broadcast(errors: 'No permission') unless allowed_to?(:remove?, menu_item)

    menu_item.destroy
    broadcast(delete: true, menu_item: true, id: menu_item.id, folderId: menu_item.folder_id, menuId: menu_item.menu_id)
  end

  def change_access(data)
    menu_item = by_data(data)
    return broadcast(errors: 'menu item not found') if menu_item.nil?
    return broadcast(errors: 'No permission') unless allowed_to?(:change_access?, menu_item)

    responds(Acl::Access, params.merge(data)) do |item|
      responds(Menus::Folders::List, { menu_id: item.menu_id, user_id: current_user.id }) do |result|
        broadcast(access: true, menu_item: Menus::FolderSerializer.new(result))
      end
    end
  end

  private

  def by_data(data)
    Menus::Item.find_by(id: data['id'])
  end

  def item_serializer(item)
    Menus::ItemSerializer.new(item)
  end
end
