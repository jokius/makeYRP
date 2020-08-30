# frozen_string_literal: true

class Pages::GraphicsController < ::ApplicationController
  def index
    graphics = authorized_scope(page.graphics, scope_options: { game: page.game })
    render json: GraphicSerializer.new(graphics)
  end

  private

  def page
    @page ||= Page.find(params[:page_id])
  end
end
