# frozen_string_literal: true

class Games::MessagesController < Games::ApplicationController
  def index
    render json: game.limit_messages(20)
  end
end
