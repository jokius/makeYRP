# frozen_string_literal: true

class PageChannel < ApplicationCable::Channel
  def subscribed
    stream_for page
  end

  def add(data)
    case data['type']
    when 'token'
      responds(Tokens::Create, params.merge(data)) { |token| broadcast(new: true, token: TokenSerializer.new(token)) }
    when 'image'
      responds(Images::Create, params.merge(data)) { |image| broadcast(new: true, image: ImageSerializer.new(image)) }
    when 'graphic'
      responds(Graphics::Create, params.merge(data)) { |graphic| broadcast(new: true, graphic: graphic) }
    else
      broadcast(errors: "incorrect type found #{data['type']}")
    end
  end

  def change(data)
    case data['type']
    when 'token'
      responds(Tokens::Update, params.merge(data)) do |token|
        broadcast(update: true, token: TokenSerializer.new(token))
      end

    when 'image'
      responds(Images::Update, params.merge(data)) do |image|
        broadcast(update: true, image: ImageSerializer.new(image))
      end

    when 'graphic'
      responds(Graphics::Update, params.merge(data)) { |token| broadcast(update: true, graphic: token) }
    else
      broadcast(errors: "incorrect type found #{data['type']}")
    end
  end

  def remove(data)
    case data['type']
    when 'token'
      remove_token(token_by_data(data))
    when 'image'
      remove_image(image_by_data(data))
    when 'graphic'
      remove_graphic(graphic_by_data(data))
    else
      broadcast(errors: "incorrect type found #{data['type']}")
    end
  end

  private

  def broadcast(data)
    PageChannel.broadcast_to(page, data)
  end

  def page
    Page.find(params[:page_id])
  end

  def remove_token(token)
    return broadcast(errors: 'token not found') if token.nil?

    broadcast(delete: true, token: { id: token.delete.id })
  end

  def remove_image(image)
    return broadcast(errors: 'image not found') if image.nil?

    broadcast(delete: true, image: { id: image.delete.id })
  end

  def remove_graphic(graphic)
    return broadcast(errors: 'graphic not found') if graphic.nil?

    graphic.delete
    broadcast(delete: true, graphic: { id: graphic.id, layer: graphic.layer })
  end

  def token_by_data(data)
    Token.find_by(id: data['id'])
  end

  def image_by_data(data)
    Image.find_by(id: data['id'])
  end

  def graphic_by_data(data)
    Graphic.find_by(id: data['id'])
  end
end
