# frozen_string_literal: true

class FoldersController < ApplicationController
  def create
    responds(Folders::Create, params.merge(user_id: current_user.id)) do |result|
      render json: FolderSerializer.new(result, include: %i[children images]), status: :created
    end
  end

  def show
    folder = folders.find_by(id: params[:id]) || folders.root
    render json: FolderSerializer.new(folder, include: %i[children images])
  end

  def update
    responds(Folders::Update, params) do |result|
      render json: FolderSerializer.new(result, include: %i[children images]), status: :created
    end
  end

  def destroy
    folder.destroy
    head :no_content
  end

  def tree
    render json: FolderTreeSerializer.new(folders.root)
  end

  private

  def folders
    @folders ||= current_user.folders
  end

  def folder
    @folder ||= Folder.find(params[:id])
  end
end
