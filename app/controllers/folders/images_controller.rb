# frozen_string_literal: true

class Folders::ImagesController < ApplicationController
  def create
    responds(Folders::Images::Create, params, status: :created)
  end
end
