# frozen_string_literal: true

class Games::MessagesController < Games::ApplicationController
  def index
    render json: game.limit_messages(20)
  end

  def create
    responds(Messages::Create, params.merge(user_id: current_user.id)) do |message|
      ChatChannel.broadcast_to(game, MessageSerializer.new(message))
    end
  end
end
