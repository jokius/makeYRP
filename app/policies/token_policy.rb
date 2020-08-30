# frozen_string_literal: true

class TokenPolicy < ApplicationPolicy
  include ::AclScopes

  relation_scope(:owner) { |scope| scope.joins(:sheet).where(sheets: { owner: user }) }
end
