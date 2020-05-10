# frozen_string_literal: true

class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_for game
  end

  def add(data)
    case data['type']
    when 'sheet'
      add_sheet(data)
    when 'page'
      add_page(data)
    when 'message'
      add_message(data)
    when 'menu_item'
      add_menu_item(data)
    else
      broadcast(errors: "incorrect type found #{data['type']}")
    end
  end

  def change(data)
    case data['type']
    when 'sheet'
      return change_access('write') unless allowed_to?(:write?, sheet_by_data(data))

      responds(Sheets::Update, params.merge(data)) do |sheet|
        SheetChannel.broadcast_to(sheet, sheet_serializer(sheet))
        broadcast(update: true, sheet: sheet_serializer(sheet))
      end
    when 'page'
      responds(Pages::Update, params.merge(data)) { |page| broadcast(update: true, page: page) }
    when 'menu_item'
      responds(Menus::Items::Update, params.merge(data)) { |menu_item| broadcast(update: true, menu_item: menu_item) }
    else
      broadcast(errors: "incorrect type found #{data['type']}")
    end
  end

  def remove(data)
    case data['type']
    when 'sheet'
      sheet = sheet_by_data(data)
      return change_access('remove') unless allowed_to?(:remove?, sheet)

      remove_sheet(sheet)
    when 'page'
      remove_page(page_by_data(data))
    when 'menu_item'
      remove_menu_item(menu_item_by_data(data))
    else
      broadcast(errors: "incorrect type found #{data['type']}")
    end
  end

  def change_access(data)
    case data['type']
    when 'sheet'
      sheet = sheet_by_data(data)
      return change_access('change_access') unless allowed_to?(:change_access?, sheet)

      access_sheet(data)
    else
      broadcast(errors: "incorrect type found #{data['type']}")
    end
  end

  private

  def no_permission(action)
    broadcast(errors: "no permission to #{action}")
  end

  def broadcast(data)
    GameChannel.broadcast_to(game, data)
  end

  def add_sheet(data)
    responds(Sheets::Create, params.merge(data).merge(owner_id: current_user.id)) do |sheet|
      broadcast(new: true, sheet: sheet_serializer(sheet))
    end
  end

  def remove_sheet(sheet)
    return broadcast(errors: 'sheet not found') if sheet.nil?

    sheet.destroy
    SheetChannel.broadcast_to(sheet, delete: sheet.id)
    broadcast(delete: true, sheet: sheet.id)
  end

  def access_sheet(data)
    responds(Sheets::Access, params.merge(data)) do |sheet|
      broadcast(access: true, sheet: sheet_serializer(sheet))
    end
  end

  def add_page(data)
    responds(Pages::Create, params.merge(data)) { |page| broadcast(new: true, page: page) }
  end

  def remove_page(page)
    return broadcast(errors: 'page not found') if page.nil?

    broadcast(delete: true, page: page.destroy.id)
  end

  def remove_menu_item(menu_item)
    return broadcast(errors: 'menu item not found') if menu_item.nil?

    menu_item.destroy
    broadcast(delete: true, menu_item: true, id: menu_item.id, menu_id: menu_item.menu_id)
  end

  def add_message(data)
    responds(Messages::Create, params.merge(data).merge(user_id: current_user.id)) do |message|
      broadcast(new: true, message: MessageSerializer.new(message))
    end
  end

  def add_menu_item(data)
    responds(Menus::Items::Create, params.merge(data)) do |item|
      broadcast(new: true, menu_item: Menus::ItemSerializer.new(item))
    end
  end

  def game
    @game ||= Game.find(params[:game_id])
  end

  def sheet_serializer(sheet)
    SheetSerializer.new(sheet)
  end

  def sheet_by_data(data)
    Sheet.find_by(id: data['id'])
  end

  def page_by_data(data)
    Page.find_by(id: data['id'])
  end

  def menu_item_by_data(data)
    Menus::Item.find_by(id: data['id'])
  end
end
