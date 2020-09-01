# frozen_string_literal: true

class Games::MessagesController < Games::ApplicationController
  def index
    render json: MessageSerializer.new(game.limit_messages(20), { include: %i[user] })
  end
end
