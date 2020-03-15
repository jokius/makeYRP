# frozen_string_literal: true

class Games::SheetsController < Games::ApplicationController
  def index
    # TODO: add pundit scope
    respond_json json: Sheet.where(game: game)
  end
end
