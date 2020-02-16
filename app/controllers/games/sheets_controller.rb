# frozen_string_literal: true

class Games::SheetsController < Games::ApplicationController
  def index
    # TODO: add pundit scope
    respond_json json: Sheet.where(game: game)
  end

  def create
    responds(Sheets::Create, params.merge(owner_id: current_user.id)) do |sheet|
      GameChannel.broadcast_to(game, new: true, sheet: sheet)
    end
  end

  def update
    responds(Sheets::Update, params) do |raw|
      sheet = SheetSerializer.new(raw)
      SheetChannel.broadcast_to(raw, sheet)
      GameChannel.broadcast_to(game, update: true, sheet: sheet)
    end
  end

  def destroy
    sheet.delete
    SheetChannel.broadcast_to(sheet, delete: sheet.id)
    GameChannel.broadcast_to(game, delete: true, sheet: sheet.id)
  end

  private

  def sheet
    @sheet ||= Sheet.find(params[:id])
  end
end
