# frozen_string_literal: true

class Games::SheetsController < Games::ApplicationController
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
    sheet_id = sheet.id
    sheet.delete
    SheetChannel.broadcast_to(sheet, delete: sheet_id)
    SheetsChannel.broadcast_to(game, delete: sheet_id)
  end

  private

  def sheet
    @sheet ||= Sheet.find(params[:id])
  end
end
