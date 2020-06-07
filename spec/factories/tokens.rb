# frozen_string_literal: true

# == Schema Information
#
# Table name: tokens
#
#  id         :bigint           not null, primary key
#  page_id    :bigint           not null
#  sheet_id   :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  params     :jsonb            not null
#

FactoryBot.define do
  factory :token do
    page
    sheet
    params { { x: 0, y: 0 } }
  end
end
