# frozen_string_literal: true

class ApplicationCable::Channel < ActionCable::Channel::Base
  include ActionPolicy::Behaviour

  class Failure < StandardError; end

  protected

  authorize :user, through: :current_user

  def responds(interactor, input, &block)
    result = interactor.new.call(input)
    return broadcast(errors: result.failure) if result.failure?

    yield(result.success) if block
  end
end
