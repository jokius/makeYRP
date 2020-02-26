# frozen_string_literal: true

class PageChannel < ApplicationCable::Channel
  def subscribed
    stream_for page
  end

  def add_token(data)
    result = Tokens::Create.new.call(params.merge(data))
    PageChannel.broadcast_to(page, new: true, token: result.success) if result.success?
  end

  def move_token(data)
    result = Tokens::Update.new.call(params.merge(data))
    PageChannel.broadcast_to(page, update: true, token: result.success) if result.success?
  end

  def remove_token(data)
    token = token_by_data(data)
    token.delete
    PageChannel.broadcast_to(page, delete: true, token: { id: token.id })
  end

  private

  def page
    Page.find(params[:page_id])
  end

  def token_by_data(data)
    Token.find(data['id'])
  end
end
