# frozen_string_literal: true

class Games::ItemsController < Games::ApplicationController
  def index
    list = game.items.group_by(&:item_type).map do |type, items|
      { name: type, children: items.map { |item| ItemSerializer.new(item) } }
    end

    render json: list
  end
end
