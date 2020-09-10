# frozen_string_literal: true

class Helpers::Image < Helpers::Base
  def add(data)
    responds(Images::Create, params.merge(data).merge(owner_id: current_user.id)) do |item|
      broadcast(new: true, image: image_serializer(item))
    end
  end

  def change(data)
    return broadcast(errors: 'No permission') unless allowed_to?(:write?, by_data(data))

    responds(Images::Update, params.merge(data)) do |item|
      broadcast(update: true, image: image_serializer(item), from: current_user.id.to_s)
    end
  end

  def remove(data)
    image = by_data(data)
    return broadcast(errors: 'image not found') if image.nil?
    return broadcast(errors: 'No permission') unless allowed_to?(:remove?, image)

    image.destroy
    broadcast(delete: true, image: true, id: image.id)
  end

  private

  def by_data(data)
    Image.find_by(id: data['id'])
  end

  def image_serializer(item)
    ImageSerializer.new(item)
  end
end
