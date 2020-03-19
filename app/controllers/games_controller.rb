# frozen_string_literal: true

class GamesController < ApplicationController
  def index
    games = authorized_scope(Game.order(created_at: :desc), as: :all, scope_options: games_params)
    respond_json json: games, each_serializer: ShortGameSerializer
  end

  def new
    respond_json nil
  end

  def create
    responds(Games::Create, params.merge(master_id: current_user.id)) do |game|
      respond_json json: { id: game.id }, status: :created
    end
  end

  def show
    respond_json json: game, include: %w[master users pages menus.items]
  end

  def join
    responds(Games::Join, game_id: game.id, user_id: current_user.id) do |game|
      respond_json json: { id: game.id }, status: :created
    end
  end

  private

  def games_params
    params.permit(:open).to_h.symbolize_keys
  end

  def game
    @game ||= Game.find(params[:id])
  end
end
