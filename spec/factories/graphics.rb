# frozen_string_literal: true

# == Schema Information
#
# Table name: graphics
#
#  id         :bigint           not null, primary key
#  page_id    :bigint           not null
#  layer      :string
#  params     :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :graphic do
    page
  end
end
