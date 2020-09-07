# frozen_string_literal: true

class GameChannel < ApplicationCable::Channel
  def subscribed
    user_connected
    stream_for game
  end

  def unsubscribed
    user_disconnected
  end

  def add(data)
    return incorrect_type(data) unless %w[sheet page message item_folder menu_item].include? data['type']

    send(data['type']).add(data)
  end

  def change(data)
    return incorrect_type(data) unless %w[sheet page item_folder menu_item user].include? data['type']

    send(data['type']).change(data)
  end

  def remove(data)
    return incorrect_type(data) unless %w[sheet page item_folder menu_item].include? data['type']

    send(data['type']).remove(data)
  end

  def clone(data)
    return incorrect_type(data) unless %w[sheet].include? data['type']

    send(data['type']).clone(data)
  end

  def change_access(data)
    return incorrect_type(data) unless %w[sheet menu_item].include? data['type']

    send(data['type']).change_access(data)
  end

  private

  def game
    @game ||= Game.find(params[:game_id])
  end

  def broadcast(data)
    GameChannel.broadcast_to(game, data)
  end

  def incorrect_type(data)
    broadcast(errors: "incorrect type found #{data['type']}")
  end

  def helper_params
    { channel: GameChannel, object: game, params: params, current_user: current_user }
  end

  def page
    @page ||= Helpers::Page.new.call(**helper_params)
  end

  def sheet
    @sheet ||= Helpers::Sheet.new.call(**helper_params)
  end

  def message
    @message ||= Helpers::Message.new.call(**helper_params)
  end

  def item_folder
    @item_folder ||= Helpers::ItemFolder.new.call(**helper_params)
  end

  def menu_item
    @menu_item ||= Helpers::MenuItem.new.call(**helper_params)
  end

  def user
    @user ||= Helpers::User.new.call(**helper_params)
  end

  def user_connected
    return add_user if REDIS.get(key)

    add_user
    broadcast(new: true, user: ShortUserSerializer.new(current_user, { params: { game: game } }))
  end

  def add_user
    REDIS.set(key, current_user.id.to_s, ex: 2.days)
  end

  def user_disconnected
    change_list
    broadcast(delete: true, user: current_user.id)
  end

  def change_list
    REDIS.del(key)
  end

  def key
    "game_#{game.id}_user_#{current_user.id}"
  end
end
