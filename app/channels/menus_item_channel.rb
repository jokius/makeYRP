# frozen_string_literal: true

class MenusItemChannel < ApplicationCable::Channel
  def subscribed
    stream_for item
  end

  def change(data)
    return broadcast(errors: 'data is blank') if data.blank?

    item.update(params: data)
    broadcast(Menus::ItemSerializer.new(item))
  end

  def remove
    item.delete
    broadcast(delete: { id: item.id, menu_id: item.menu_id })
  end

  private

  def broadcast(data)
    MenusItemChannel.broadcast_to(item, data)
  end

  def item
    @item ||= Menus::Item.find(params[:item_id])
  end
end
