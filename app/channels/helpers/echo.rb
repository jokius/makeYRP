# frozen_string_literal: true

class Helpers::Echo < Helpers::Base
  def add(data)
    broadcast(new: true, echo: true, position: data['position'], color: current_user.color, from: current_user.id.to_s)
  end
end
