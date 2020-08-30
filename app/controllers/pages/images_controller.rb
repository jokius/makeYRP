# frozen_string_literal: true

class Pages::ImagesController < ::ApplicationController
  def index
    images = authorized_scope(page.images, scope_options: { game: page.game })
    render json: ImageSerializer.new(images)
  end

  private

  def page
    @page ||= Page.find(params[:page_id])
  end
end
