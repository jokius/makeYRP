# frozen_string_literal: true

class MediasController < ApplicationController
  include ActiveStorage::SendZip

  skip_before_action :authenticate_user!, only: %i[show download]

  def create
    responds(Systems::LoadMedia, create_params) do |key|
      render json: key, status: :created
    end
  end

  def show
    return render nil unless media

    send_data(media.image.download, type: media.image.content_type, disposition: 'inline')
  end

  def download
    images = params[:keys].map { |key| Medium.find_by(key: key).image }
    send_zip images
  end

  private

  def media
    Medium.find_by(key: params[:id])
  end

  def game
    Game.find(params[:game_id])
  end

  def create_params
    file = params[:file]
    name = params[:name]
    extension = file.original_filename.split('.').last
    { id: game.system.id, name: params[:name], file_name: "#{name}.#{extension}", io_file: file.read }
  end
end
