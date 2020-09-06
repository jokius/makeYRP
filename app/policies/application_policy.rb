# frozen_string_literal: true

class ApplicationPolicy < ActionPolicy::Base
  def read?
    owner? || master?(record.game) || record.read?(user)
  end

  def write?
    owner? || master?(record.game) || record.write?(user)
  end

  def remove?
    owner? || master?(record.game)
  end

  def change_access?
    owner? || master?(record.game)
  end

  def clone?
    owner? || master?(record.game)
  end

  protected

  def admin?
    user.admin?
  end

  def master?(game)
    game.master == user
  end

  def owner?
    return false unless record.respond_to? :owner

    record.owner == user
  end
end
