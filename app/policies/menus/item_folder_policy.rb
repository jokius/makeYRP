# frozen_string_literal: true

class Menus::ItemFolderPolicy < ApplicationPolicy
  def write?
    master?(record.game)
  end

  def remove?
    master?(record.game)
  end
end
