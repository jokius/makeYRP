# frozen_string_literal: true

class Menus::ItemsController < ApplicationController
  def index
    items = authorized_scope(menu.items.order(created_at: :desc), scope_options: { game: menu.game })
    render json: items, user: current_user
  end

  private

  def menu
    @menu ||= Menu.find(params[:menu_id])
  end
end
