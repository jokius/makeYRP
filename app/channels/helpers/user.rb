# frozen_string_literal: true

class Helpers::User < Helpers::Base
  def change(data)
    data = data.merge(user_id: current_user.id)
    responds(Users::ChangeSheet, params.merge(data)) { |user| broadcast(update: true, user: user_serializer(user)) }
  end

  private

  def by_data(data)
    Page.find_by(id: data['id'])
  end

  def user_serializer(item)
    ShortUserSerializer.new(item, game: object)
  end
end
