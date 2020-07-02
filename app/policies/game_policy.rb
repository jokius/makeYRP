# frozen_string_literal: true

class GamePolicy < ApplicationPolicy
  relation_scope :all do |scope, open|
    list = scope.where(open)
    games = authorized_scope(list, as: :master, scope_options: { open: open })
    games |= authorized_scope(list, as: :player, scope_options: { open: open })
    games | list
  end

  relation_scope :master do |scope, open|
    scope.where(open.merge(master: user))
  end

  relation_scope :player do |scope, open|
    scope.joins(:users).where(open.merge(users: { id: user.id }))
  end

  def switch_status?
    master?(record)
  end

  def config_show?
    master?(record)
  end

  def update?
    master?(record)
  end
end
