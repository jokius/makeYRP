# frozen_string_literal: true

# == Schema Information
#
# Table name: tokens
#
#  id         :bigint           not null, primary key
#  layer      :string           not null
#  params     :jsonb            not null
#  read_all   :boolean          default(FALSE), not null
#  write_all  :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  page_id    :bigint           not null
#  sheet_id   :bigint           not null
#
# Indexes
#
#  index_tokens_on_page_id   (page_id)
#  index_tokens_on_sheet_id  (sheet_id)
#

FactoryBot.define do
  factory :token do
    layer { 'players' }
    page
    sheet
    params { { x: 0, y: 0 } }
  end
end
