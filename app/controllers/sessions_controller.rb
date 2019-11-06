# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  clear_respond_to
  respond_to :json

  def new; end
end
