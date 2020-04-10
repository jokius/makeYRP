# frozen_string_literal: true

module Acl
  extend ActiveSupport::Concern
  included do
    has_many :access_levels, as: :object, dependent: :destroy
  end

  def owner?(user)
    return false unless respond_to? :owner

    owner == user
  end

  def read?(user)
    write_all? || read_all? ||
      access_levels.where(user: user, read: true).or(access_levels.where(user: user, write: true)).any?
  end

  def write?(user)
    write_all? || access_levels.where(user: user, write: true).any?
  end
end
