# frozen_string_literal: true

class FolderImageSerializer < BaseSerializer
  attributes :name

  attribute :versions do |image|
    { url: image.image_url,
      chat: image.image_chat,
      lazy: image.image_lazy,
      thumb: image.image_thumb }
  end
end
