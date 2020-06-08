# frozen_string_literal: true

class Pages::TokensController < ::ApplicationController
  def index
    tokens = authorized_scope(page.tokens, scope_options: { game: page.game })
    render json: tokens
  end

  private

  def page
    @page ||= Page.find(params[:page_id])
  end
end
