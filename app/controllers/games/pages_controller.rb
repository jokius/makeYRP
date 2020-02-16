# frozen_string_literal: true

class Games::PagesController < Games::ApplicationController
  def create
    responds(Pages::Create, params, status: :created) do |page|
      PagesChannel.broadcast_to(game, page: PageSerializer.new(page), new: true)
    end
  end

  def update
    responds(Pages::Update, params, status: :created) do |page|
      PagesChannel.broadcast_to(game, page: PageSerializer.new(page), new: false)
    end
  end

  def destroy
    page.delete
    PagesChannel.broadcast_to(game, delete: page.id)
  end

  private

  def page
    @page ||= Page.find(params[:id])
  end
end
