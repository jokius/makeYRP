# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  before_action do
    class_name = 'ActiveStorage::Service::DiskService'
    next unless ActiveStorage::Blob.service.class.name == class_name

    Rails.application.routes.default_url_options[:only_path] = true
  end

  def access_denied(exception)
    redirect_to root_path, alert: exception.message
  end

  def authenticate_admin_user!
    if current_user&.admin?
      current_user
    else
      redirect_to root_path
    end
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
