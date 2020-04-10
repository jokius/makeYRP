# frozen_string_literal: true

class ShortGameSerializer < ActiveModel::Serializer
  attributes :id, :name
  attribute :system do
    object.system.name
  end

  belongs_to :master, serializer: ShortUserSerializer
  has_many :users, serializer: ShortUserSerializer
end
