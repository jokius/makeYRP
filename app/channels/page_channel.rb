# frozen_string_literal: true

class PageChannel < ApplicationCable::Channel
  state_attr_accessor :token, :image, :graphic, :echo

  def subscribed
    stream_for page
  end

  def add(data)
    return incorrect_type(data) unless %w[token image graphic echo].include? data['type']

    send(data['type']).add(data)
  end

  def change(data)
    return incorrect_type(data) unless %w[token image graphic].include? data['type']

    send(data['type']).change(data)
  end

  def remove(data)
    return incorrect_type(data) unless %w[token image graphic].include? data['type']

    send(data['type']).remove(data)
  end

  private

  def page
    Page.find(params[:page_id])
  end

  def broadcast(data)
    PageChannel.broadcast_to(page, data)
  end

  def incorrect_type(data)
    broadcast(errors: "incorrect type found #{data['type']}")
  end

  def helper_params
    { channel: PageChannel, object: page, params: params, current_user: current_user }
  end

  def token
    @token ||= Helpers::Token.new.call(**helper_params)
  end

  def image
    @image ||= Helpers::Image.new.call(**helper_params)
  end

  def graphic
    @graphic ||= Helpers::Graphic.new.call(**helper_params)
  end

  def echo
    @echo ||= Helpers::Echo.new.call(**helper_params)
  end
end
