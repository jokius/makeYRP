# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  before_action do
    class_name = 'ActiveStorage::Service::DiskService'
    next unless ActiveStorage::Blob.service.class.name == class_name

    ActiveStorage::Current.host = request.base_url
    Rails.application.routes.default_url_options[:host] = request.base_url
  end

  protected

  def responds(interactor, input, status: :ok, &block)
    input = input.permit!.to_h if input.is_a? ActionController::Parameters
    interactor.new.call(input) do |result|
      result.success do |value|
        return yield(value) if block

        respond_json json: value, status: status
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
