# frozen_string_literal: true

class Games::PagesController < Games::ApplicationController
  def create
    responds(Pages::Create, params, status: :created)
  end

  def update
    responds(Pages::Update, params, status: :created)
  end

  def destroy
    page.delete
    head :no_content
  end

  private

  def page
    @page ||= Page.find(params[:id])
  end
end
