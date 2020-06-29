# frozen_string_literal: true

class GamesController < ApplicationController
  def index
    games = authorized_scope(Game.order(created_at: :desc), as: :all, scope_options: games_params)
    render json: games, each_serializer: ShortGameSerializer
  end

  def create
    responds(Games::Create, params.merge(master_id: current_user.id)) do |game|
      render json: { id: game.id }, status: :created
    end
  end

  def show
    responds(Games::Join, game_id: params[:id], user_id: current_user.id) do |game|
      render json: game, include: %w[master users pages menus.items]
    end
  end

  def join
    responds(Games::Join, game_id: params[:id], user_id: current_user.id) do |game|
      render json: { id: game.id }, status: :created
    end
  end

  def update
    authorize! game

    head :no_content
    responds(Games::Update, params) do
      head :no_content
    end
  end

  def switch_status
    authorize! game

    game.update(open: !game.open)
    head :no_content
  end

  private

  def games_params
    params.permit(:open).to_h.symbolize_keys
  end

  def game
    @game ||= Game.find(params[:id])
  end
end
