# frozen_string_literal: true

require 'dry/monads/all'

class ApplicationController < ActionController::Base
  include Dry::Monads

  before_action :authenticate_user!
  before_action do
    class_name = 'ActiveStorage::Service::DiskService'
    next unless ActiveStorage::Blob.service.class.name == class_name

    Rails.application.routes.default_url_options[:only_path] = true
  end

  protected

  def responds(interactor, input, status: :ok, &block)
    input = input.permit!.to_h if input.is_a? ActionController::Parameters
    result = interactor.new.call(input)
    return yield(result.success) if block && result.success?

    respond = case result
              when Success
                { json: result.success, status: status }
              else
                { json: error[:message], status: (error[:status] || 400) }
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
