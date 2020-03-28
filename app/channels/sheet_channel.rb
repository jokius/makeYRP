# frozen_string_literal: true

class SheetChannel < ApplicationCable::Channel
  def subscribed
    sheet = Sheet.find(params[:sheet_id])
    stream_for SheetSerializer.new(sheet, user: current_user)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
