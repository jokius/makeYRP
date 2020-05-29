# frozen_string_literal: true

class Admin::GamesController < Admin::ApplicationController
  def index
    render json: Game.order(created_at: :desc), each_serializer: ShortGameSerializer
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
