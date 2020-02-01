# frozen_string_literal: true

class Games::MenusItemsController < Games::ApplicationController
  def create
    responds(Menus::Items::Create, params) do |item|
      MenusItemsChannel.broadcast_to(game, Menus::ItemSerializer.new(item))
    end
  end

  def update
    item.update(params: params[:params])
    MenusItemChannel.broadcast_to(item, Menus::ItemSerializer.new(item))
  end

  def destroy
    item.delete
    MenusItemChannel.broadcast_to(item, delete: { id: item.id, menu_id: item.menu_id })
  end

  private

  def item
    @item ||= Menus::Item.find(params[:id])
  end
end
