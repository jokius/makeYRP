# frozen_string_literal: true

class ShortGameSerializer < BaseSerializer
  attributes :name
  attribute :system do |game|
    game.system.name
  end

  belongs_to :master, serializer: ShortUserSerializer
  has_many :users, serializer: ShortUserSerializer
end
