# frozen_string_literal: true

class GamesController < ApplicationController
  def index
    list = Game.where(games_params).order(created_at: :desc)
    games = list.where(master: current_user)
    games |= list.joins(:users).where(users: { id: current_user.id })
    games |= list

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

  private

  def games_params
    params.permit(:open)
  end

  def game
    @game ||= Game.find(params[:id])
  end
end
