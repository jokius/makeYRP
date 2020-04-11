# frozen_string_literal: true

class UsersAclSerializer < ActiveModel::Serializer
  attributes :id, :write_all, :read_all
  attribute :levels do
    instance_options[:users].map do |user|
      { user: ShortUserSerializer.new(user),
        owner: object.owner?(user),
        read: object.read?(user),
        write: object.write?(user) }
    end
  end
end
