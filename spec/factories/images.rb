# frozen_string_literal: true

# == Schema Information
#
# Table name: images
#
#  id         :bigint           not null, primary key
#  params     :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  page_id    :bigint           not null
#
# Indexes
#
#  index_images_on_page_id  (page_id)
#

FactoryBot.define do
  factory :image do
    page
    params { { x: 0, y: 0 } }
  end
end
