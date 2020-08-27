# frozen_string_literal: true

class Helpers::Page < Helpers::Base
  def add(data)
    responds(Pages::Create, params.merge(data)) { |page| broadcast(new: true, page: page_serializer(page)) }
  end

  def change(data)
    responds(Pages::Update, params.merge(data)) { |page| broadcast(update: true, page: page_serializer(page)) }
  end

  def remove(data)
    page = by_data(data)
    return broadcast(errors: 'page not found') if page.nil?

    broadcast(delete: true, page: page.destroy.id)
  end

  private

  def by_data(data)
    Page.find_by(id: data['id'])
  end

  def page_serializer(item)
    PageSerializer.new(item)
  end
end
