# frozen_string_literal: true

class Games::SheetsController < Games::ApplicationController
  def index
    responds(Sheets::Folders::List, params.merge(user_id: current_user.id)) do |result|
      render json: Sheets::FolderSerializer.new(result)
    end
  end
end
