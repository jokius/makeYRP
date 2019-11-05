# frozen_string_literal: true

class Games::PagesController < ApplicationController
  def create
    responds(Pages::Create, params) do |page|
      respond_json json: page, status: :created
    end
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
