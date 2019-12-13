# frozen_string_literal: true

class Games::SheetsController < ApplicationController
  def index
    # TODO: add pundit scope
    respond_json json: Sheet.where(game: game)
  end

  def create
    responds(Sheets::Create, params.merge(owner_id: current_user.id)) do |sheet|
      SheetsChannel.broadcast_to(game, sheet: SheetSerializer.new(sheet), new: true)
    end
  end

  def update
    responds(Sheets::Update, params) do |raw|
      sheet = SheetSerializer.new(raw)
      SheetChannel.broadcast_to(raw, sheet)
      SheetsChannel.broadcast_to(game, sheet: sheet, new: false)
    end
  end

  def destroy
    sheet.delete
    SheetChannel.broadcast_to(sheet, delete: sheet.id)
    SheetsChannel.broadcast_to(game, delete: sheet.id)
  end

  private

  def game
    @game ||= Game.find(params[:game_id])
  end

  def sheet
    @sheet ||= Sheet.find(params[:id])
  end
end
