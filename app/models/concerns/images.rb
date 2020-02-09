# frozen_string_literal: true

module Images
  THUMB = 200
  CHAT = 50
  LAZY = 10

  def images_version(name, add_versions: [])
    url(name)
    version(name, version: 'thumb', width: THUMB)
    version(name, version: 'chat', width: CHAT)
    version(name, version: 'lazy', width: LAZY)
    add_versions.each do |av|
      raise 'add versions version is required' if av[:version].blank?
      raise 'add versions width is required' if av[:width].blank?

      version(name, **av)
    end
  end

  private

  def url(name)
    define_method("#{name}_url") do
      image = send(name)
      return nil unless image.attached?

      Rails.application.routes.url_helpers.url_for(image)
    end
  end

  def version(name, options = {})
    define_method("#{name}_#{options[:version]}") do
      image = send(name)
      return nil unless image.attached?

      version = image.variant(resize_to_fit: [options[:width], options[:height]]).processed
      Rails.application.routes.url_helpers.url_for(version)
    end
  end
end
