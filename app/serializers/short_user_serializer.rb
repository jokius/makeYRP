# frozen_string_literal: true

class ShortUserSerializer < ActiveModel::Serializer
  attributes :id, :nickname, :avatar, :admin

  attribute :avatar do
    { url: object.avatar_url,
      lazy: object.avatar_lazy,
      thumb: object.avatar_thumb,
      chat: object.avatar_chat }
  end
end
