# frozen_string_literal: true

class FoldersController < ApplicationController
  def create
    responds(Folders::Create, params.merge(user_id: current_user.id), status: :created)
  end

  def show
    render json: folders.find_by(id: params[:id]) || folders.root
  end

  def update
    responds(Folders::Update, params, status: :created)
  end

  def destroy
    folder.destroy
    head :no_content
  end

  def tree
    render json: folders.root, serializer: FolderTreeSerializer
  end

  private

  def folders
    @folders ||= current_user.folders
  end

  def folder
    @folder ||= Folder.find(params[:id])
  end
end
