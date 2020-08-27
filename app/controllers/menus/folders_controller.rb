# frozen_string_literal: true

class Menus::FoldersController < ApplicationController
  def index
    responds(Menus::Folders::List, params.merge(user_id: current_user.id)) do |result|
      render json: Menus::FolderSerializer.new(result)
    end
  end
end
