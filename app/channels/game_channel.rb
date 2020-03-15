# frozen_string_literal: true

class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_for game
  end

  def add(data)
    case data['type']
    when 'sheet'
      responds(Sheets::Create, params.merge(data).merge(owner_id: current_user.id)) do |sheet|
        broadcast(new: true, sheet: sheet)
      end
    else
      broadcast(errors: "incorrect type found #{data['type']}")
    end
  end

  def change(data)
    case data['type']
    when 'sheet'
      responds(Sheets::Update, params.merge(data)) do |sheet|
        SheetChannel.broadcast_to(sheet, sheet)
        broadcast(update: true, sheet: sheet)
      end
    else
      broadcast(errors: "incorrect type found #{data['type']}")
    end
  end

  def remove(data)
    case data['type']
    when 'sheet'
      remove_sheet(sheet_by_data(data))
    else
      broadcast(errors: "incorrect type found #{data['type']}")
    end
  end

  private

  def broadcast(data)
    GameChannel.broadcast_to(game, data)
  end

  def remove_sheet(sheet)
    return broadcast(errors: 'sheet not found') if sheet.nil?

    sheet.destroy
    SheetChannel.broadcast_to(sheet, delete: sheet.id)
    broadcast(delete: true, sheet: sheet.id)
  end

  def game
    @game ||= Game.find(params[:game_id])
  end

  def sheet_by_data(data)
    Sheet.find_by(id: data['id'])
  end
end
