# frozen_string_literal: true

class Folders::ImagesController < ApplicationController
  def create
    responds(Folders::Images::Create, params, status: :created)
  end

  def update
    responds(Folders::Images::Update, params) do |image|
      render json: image, serializer: ImageSerializer, status: :created
    end
  end

  def destroy
    image.destroy
    head :no_content
  end

  private

  def image
    @image ||= FolderFile.find_by(id: params[:id])
  end
end
