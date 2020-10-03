# frozen_string_literal: true

class Games::SheetFolderPolicy < ApplicationPolicy
  def write?
    master?(record.game)
  end

  def remove?
    master?(record.game)
  end
end
