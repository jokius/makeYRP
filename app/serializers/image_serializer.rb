# frozen_string_literal: true

class ImageSerializer < ActiveModel::Serializer
  attributes :id, :name

  attribute :versions do
    { url: object.image_url,
      lazy: object.image_lazy,
      thumb: object.image_thumb }
  end
end
