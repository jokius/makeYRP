# frozen_string_literal: true

class GamePolicy < ApplicationPolicy
  relation_scope :all do |scope, open|
    list = scope.where(open: open)
    games = authorized_scope(list, as: :master, scope_options: { open: open })
    games |= authorized_scope(list, as: :player, scope_options: { open: open })
    games | list
  end

  relation_scope :master do |scope, open|
    scope.where(open: open, master: user)
  end

  relation_scope :player do |scope, open|
    scope.joins(:users).where(open: open, users: { id: user.id })
  end
end
