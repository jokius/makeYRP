# frozen_string_literal: true

class ApplicationPolicy < ActionPolicy::Base
  protected

  def admin?
    user.admin?
  end
end
