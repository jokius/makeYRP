# frozen_string_literal: true

class Games::SheetsController < ApplicationController
  def index
    # TODO: add pundit scope
    respond_json json: Sheet.where(game: game)
  end

  def create
    responds(Sheets::Create, params.merge(owner_id: current_user.id)) do |sheet|
      respond_json json: sheet, status: :created
    end
  end

  def destroy
    sheet.delete
    head :no_content
  end

  private

  def game
    @game ||= Game.find(params[:game_id])
  end

  def sheet
    @sheet ||= Sheet.find(params[:id])
  end
end
