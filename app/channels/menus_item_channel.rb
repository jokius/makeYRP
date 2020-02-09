# frozen_string_literal: true

class MenusItemChannel < ApplicationCable::Channel
  def subscribed
    item = Menus::Item.find(params[:id])
    stream_for item
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
