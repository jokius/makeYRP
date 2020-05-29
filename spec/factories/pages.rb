# frozen_string_literal: true

# == Schema Information
#
# Table name: pages
#
#  id         :bigint           not null, primary key
#  game_id    :bigint           not null
#  name       :string           not null
#  params     :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :page do
    game
    name { FFaker::Product.product_name }
  end
end
