# frozen_string_literal: true

class Games::MenusItemsController < Games::ApplicationController
  def create
    responds(Menus::Items::Create, params) do |item|
      MenusItemsChannel.broadcast_to(game, Menus::ItemSerializer.new(item))
    end
  end
end
