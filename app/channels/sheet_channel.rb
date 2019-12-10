# frozen_string_literal: true

class SheetChannel < ApplicationCable::Channel
  def subscribed
    sheet = Sheet.find(params[:sheet_id])
    stream_for sheet
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
