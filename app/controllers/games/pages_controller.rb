# frozen_string_literal: true

class Games::PagesController < Games::ApplicationController
  def create
    responds(Pages::Create, params, status: :created) do |page|
      GameChannel.broadcast_to(game, new: true, page: page)
    end
  end

  def update
    responds(Pages::Update, params, status: :created) do |page|
      GameChannel.broadcast_to(game, update: true, page: page)
    end
  end

  def destroy
    page.delete
    GameChannel.broadcast_to(game, delete: true, page: page.id)
  end

  private

  def page
    @page ||= Page.find(params[:id])
  end
end
