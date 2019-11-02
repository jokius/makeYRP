# frozen_string_literal: true

class ShortUserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :nickname, :avatar, :admin

  attribute :avatar do
    url_for(object.avatar) if object.avatar.attached?
  end
end
