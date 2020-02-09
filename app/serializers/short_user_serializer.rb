# frozen_string_literal: true

class ShortUserSerializer < ActiveModel::Serializer
  attributes :id, :nickname, :avatar, :admin
  attribute :avatars, key: :avatar
end
