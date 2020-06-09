# == Schema Information
#
# Table name: images
#
#  id         :bigint           not null, primary key
#  page_id    :bigint           not null
#  params     :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :image do
    page
    params { { x: 0, y: 0 } }
  end
end
