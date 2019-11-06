# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  protected

  def responds(interactor, input, &block)
    input = input.to_unsafe_hash if input.is_a? ActionController::Parameters
    interactor.new.call(input) do |result|
      result.success do |value|
        return yield(value) if block

        respond_json json: value
      end

      result.failure do |error|
        respond_json(json: error[:message], status: (error[:status] || 400))
      end
    end
  end

  def respond_json(json)
    respond_to do |format|
      format.html { render template: 'default/stub' }
      format.json { render json }
    end
  end
end
