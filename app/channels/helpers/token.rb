# frozen_string_literal: true

class Helpers::Token < Helpers::Base
  def add(data)
    responds(Tokens::Create, params.merge(data)) do |item|
      broadcast(new: true, token: token_serializer(item))
    end
  end

  def change(data)
    return broadcast(errors: 'No permission') unless allowed_to?(:write?, by_data(data))

    responds(Tokens::Update, params.merge(data)) do |item|
      broadcast(update: true, token: token_serializer(item))
    end
  end

  def remove(data)
    token = by_data(data)
    return broadcast(errors: 'token not found') if token.nil?
    return broadcast(errors: 'No permission') unless allowed_to?(:remove?, token)

    token.destroy
    broadcast(delete: true, token: true, id: token.id)
  end

  private

  def by_data(data)
    Token.find_by(id: data['id'])
  end

  def token_serializer(item)
    TokenSerializer.new(item)
  end
end
