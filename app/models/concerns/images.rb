# frozen_string_literal: true

module Images
  def images_version(name, add_versions: [])
    url(name)
    version(name, version: 'thumb', width: 200)
    version(name, version: 'chat', width: 50)
    version(name, version: 'lazy', width: 10)
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
