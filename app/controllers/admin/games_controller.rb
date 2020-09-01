# frozen_string_literal: true

class Admin::GamesController < Admin::ApplicationController
  def index
    games = Game.order(created_at: :desc)
    render json: ShortGameSerializer.new(games, { include: %i[master users] })
  end

  def destroy
    game.destroy
    head :no_content
  end

  private

  def game
    @game ||= Game.find(params[:id])
  end
end
