# frozen_string_literal: true

class Helpers::Graphic < Helpers::Base
  def add(data)
    responds(Graphics::Create, params.merge(data).merge(owner_id: current_user.id)) do |item|
      broadcast(new: true, graphic: graphic_serializer(item))
    end
  end

  def change(data)
    return broadcast(errors: 'No permission') unless allowed_to?(:write?, by_data(data))

    responds(Graphics::Update, params.merge(data)) do |item|
      broadcast(update: true, graphic: graphic_serializer(item))
    end
  end

  def remove(data)
    graphic = by_data(data)
    return broadcast(errors: 'graphic not found') if graphic.nil?
    return broadcast(errors: 'No permission') unless allowed_to?(:remove?, graphic)

    graphic.destroy
    broadcast(delete: true, graphic: true, id: graphic.id)
  end

  private

  def by_data(data)
    Graphic.find_by(id: data['id'])
  end

  def graphic_serializer(item)
    GraphicSerializer.new(item)
  end
end
