# frozen_string_literal: true

class SystemsController < ApplicationController
  def index
    render json: SystemSerializer.new(System.all)
  end

  def create
    authorize! System.new
    responds(Systems::Change, params) do
      head :no_content
    end
  end
end
