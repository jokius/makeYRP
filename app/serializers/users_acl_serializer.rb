# frozen_string_literal: true

class UsersAclSerializer < BaseSerializer
  attributes :write_all, :read_all
  attribute :levels do |object, params|
    params[:users].map do |user|
      { user: ShortUserSerializer.new(user),
        owner: object.owner?(user),
        read: object.read_record?(user),
        write: object.write_record?(user) }
    end
  end
end
