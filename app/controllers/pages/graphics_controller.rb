# frozen_string_literal: true

class Pages::GraphicsController < ::ApplicationController
  def index
    respond_json json: page.graphics
  end

  private

  def page
    @page ||= Page.find(params[:page_id])
  end
end
