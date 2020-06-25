# frozen_string_literal: true

class Pages::GraphicsController < ::ApplicationController
  def index
    tokens = page.graphics
    render json: tokens
  end

  private

  def page
    @page ||= Page.find(params[:page_id])
  end
end
