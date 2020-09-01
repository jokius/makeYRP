# frozen_string_literal: true

class Helpers::Message < Helpers::Base
  def add(data)
    responds(Messages::Create, params.merge(data).merge(user_id: current_user.id)) do |message|
      broadcast(new: true, message: message_serializer(message))
    end
  end

  private

  def message_serializer(item)
    MessageSerializer.new(item, { include: %i[user] })
  end
end
