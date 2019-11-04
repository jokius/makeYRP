# frozen_string_literal: true

class ShortUserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :nickname, :avatar, :admin

  attribute :avatar do
    rails_blob_path(object.avatar, only_path: true) if object.avatar.attached?
  end
end
