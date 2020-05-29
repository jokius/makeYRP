# frozen_string_literal: true

class Games::SheetsController < Games::ApplicationController
  def index
    sheets = authorized_scope(Sheet.where(game: game).order(created_at: :desc), scope_options: { game: game })
    render json: sheets, user: current_user
  end
end
