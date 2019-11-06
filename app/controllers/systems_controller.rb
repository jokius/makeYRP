# frozen_string_literal: true

class SystemsController < ApplicationController
  def index
    respond_json json: System.all
  end

  def new
    respond_json nil
  end

  def create
    responds(Systems::Change, params) do
      head :no_content
    end
  end
end
