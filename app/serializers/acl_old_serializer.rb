# frozen_string_literal: true

class AclOldSerializer < ActiveModel::Serializer
  attributes :write_all, :read_all, :owner_id, :read_ids, :write_ids
end
