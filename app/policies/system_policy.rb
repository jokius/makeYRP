# frozen_string_literal: true

class SystemPolicy < ApplicationPolicy
  def new?
    admin?
  end

  def create?
    admin?
  end
end
