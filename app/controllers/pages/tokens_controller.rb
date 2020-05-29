# frozen_string_literal: true

class Pages::TokensController < ::ApplicationController
  def index
    render json: page.tokens
  end

  private

  def page
    @page ||= Page.find(params[:page_id])
  end
end
