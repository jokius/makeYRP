# frozen_string_literal: true

class ApplicationCable::Channel < ActionCable::Channel::Base
  class Failure < StandardError; end

  protected

  def responds(interactor, input, &block)
    result = interactor.new.call(input)
    return broadcast(errors: result.failure) if result.failure?

    yield(result.success) if block
  end
end
