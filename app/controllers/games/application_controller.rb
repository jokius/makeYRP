# frozen_string_literal: true

class Games::ApplicationController < ApplicationController
  protected

  def game
    @game ||= Game.find(params[:game_id])
  end
end
