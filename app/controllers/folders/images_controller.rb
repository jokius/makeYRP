# frozen_string_literal: true

class Folders::ImagesController < ApplicationController
  def create
    responds(Folders::Images::Create, params) do |result|
      render json: FolderSerializer.new(result, include: %i[children images]), status: :created
    end
  end

  def update
    responds(Folders::Images::Update, params) do |image|
      render json: FolderImageSerializer.new(image), status: :created
    end
  end

  def destroy
    image.destroy
    head :no_content
  end

  def drop
    responds(Folders::Images::Drop, params.merge({ user_id: current_user.id })) do |image|
      PageChannel.broadcast_to(image.page, new: true, image: ImageSerializer.new(image))
      head :no_content
    end
  end

  private

  def image
    @image ||= FolderFile.find_by(id: params[:id])
  end
end
