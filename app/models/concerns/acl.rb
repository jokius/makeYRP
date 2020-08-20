# frozen_string_literal: true

module Acl
  extend ActiveSupport::Concern
  included do
    has_many :access_levels, as: :object, dependent: :destroy

    belongs_to :owner, class_name: 'User'
  end

  def owner?(user)
    return false unless respond_to? :owner

    owner == user
  end

  def read?(user)
    owner?(user) || write_all? || read_all? || read_record?(user)
  end

  def read_record?(user)
    access_levels.where(user: user, read: true).or(access_levels.where(user: user, write: true)).any?
  end

  def write?(user)
    owner?(user) || write_all? || write_record?(user)
  end

  def write_record?(user)
    access_levels.where(user: user, write: true).any?
  end

  def read_ids
    access_levels.where(read: true).or(access_levels.where(write: true)).pluck(:user_id)
  end

  def write_ids
    access_levels.where(write: true).pluck(:user_id)
  end
end
