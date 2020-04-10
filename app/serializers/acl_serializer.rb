# frozen_string_literal: true

class AclSerializer < ActiveModel::Serializer
  attribute :is_owner do
    object.owner?(instance_options[:user])
  end

  attribute :cam_read do
    object.read?(instance_options[:user])
  end

  attribute :cam_write do
    object.write?(instance_options[:user])
  end

  attribute :user do
    ShortUserSerializer.new(instance_options[:user])
  end
end
