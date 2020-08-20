# frozen_string_literal: true

# == Schema Information
#
# Table name: menus_items
#
#  id         :bigint           not null, primary key
#  menu_id    :bigint           not null
#  params     :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :bigint           not null
#  read_all   :boolean          default(FALSE), not null
#  write_all  :boolean          default(FALSE), not null
#

class Menus::Item < ApplicationRecord
  include Acl

  belongs_to :menu

  delegate :identifier, :game, to: :menu
end
