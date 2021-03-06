# frozen_string_literal: true

# == Schema Information
#
# Table name: graphics
#
#  id         :bigint           not null, primary key
#  kind       :string
#  layer      :string           not null
#  params     :jsonb
#  read_all   :boolean          default(TRUE), not null
#  write_all  :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :bigint           not null
#  page_id    :bigint           not null
#
# Indexes
#
#  index_graphics_on_layer    (layer)
#  index_graphics_on_page_id  (page_id)
#

class Graphic < ApplicationRecord
  include Acl

  belongs_to :page
  delegate :game, to: :page
end
