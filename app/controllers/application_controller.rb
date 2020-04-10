# frozen_string_literal: true

require 'dry/monads/all'

class ApplicationController < ActionController::Base
  include Dry::Monads

  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  protected

  def responds(interactor, input, status: :ok, &block)
    input = input.permit!.to_h if input.is_a? ActionController::Parameters
    result = interactor.new.call(input)
    return yield(result.success) if block && result.success?

    respond = case result
              when Success
                { json: result.success, status: status }
              else
                { json: result.failure[:message], status: (result.failure[:status] || 400) }
              end

    respond_json respond
  end

  def respond_json(json)
    respond_to do |format|
      format.html { render template: 'default/stub' }
      format.json { render json }
    end
  end
end
