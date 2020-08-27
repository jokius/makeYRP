# frozen_string_literal: true

class Helpers::Base
  include ActionPolicy::Behaviour

  attr_accessor :channel, :object, :params, :current_user

  authorize :user, through: :current_user

  def call(channel:, object:, params:, current_user:)
    @channel = channel
    @object = object
    @params = params
    @current_user = current_user
    self
  end

  protected

  def broadcast(data)
    channel.broadcast_to(object, data)
  end

  def responds(interactor, input, &block)
    result = interactor.new.call(input)
    return broadcast(errors: result.failure) if result.failure?

    yield(result.success) if block
  end

  def no_permission(type, action)
    broadcast(errors: "no permission #{action} to #{type}")
  end
end
