# frozen_string_literal: true

class SheetPolicy < ApplicationPolicy
  relation_scope do |scope, options|
    next scope if master?(options[:game])

    sheets = authorized_scope(scope, as: :owner)
    sheets |= authorized_scope(scope, as: :all)
    sheets |= authorized_scope(scope, as: :write)
    sheets | authorized_scope(scope, as: :read)
  end

  relation_scope(:owner) { |scope| scope.where(owner: user) }

  relation_scope(:all) do |scope|
    scope.where(write_all: true).or(scope.where(read_all: true))
  end

  relation_scope :write do |scope|
    scope.joins(:access_levels).where(access_levels: { user: user, write: true })
  end

  relation_scope :read do |scope|
    scope.joins(:access_levels).where(access_levels: { user: user, read: true })
  end
end
