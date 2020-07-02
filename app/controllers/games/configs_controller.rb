# frozen_string_literal: true

class Games::ConfigsController < Games::ApplicationController
  def show
    authorize! game, to: :config_show?
    render json: game, serializer: GameConfigSerializer
  end

  def update
    authorize! game

    responds(Games::Update, params) do
      head :no_content
    end
  end
end
