# frozen_string_literal: true

class Pages::ImagesController < ::ApplicationController
  def index
    render json: page.images
  end

  private

  def page
    @page ||= Page.find(params[:page_id])
  end
end
