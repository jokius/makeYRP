# frozen_string_literal: true

# == Schema Information
#
# Table name: graphics
#
#  id         :bigint           not null, primary key
#  kind       :string
#  layer      :string
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

FactoryBot.define do
  factory :graphic do
    owner { create(:user) }
    page
    kind { 'test' }
    params { { test: true } }
  end
end
