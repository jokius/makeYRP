# frozen_string_literal: true

# == Schema Information
#
# Table name: games
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  open       :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  master_id  :bigint           not null
#  system_id  :bigint           not null
#
# Indexes
#
#  index_games_on_master_id  (master_id)
#  index_games_on_system_id  (system_id)
#

FactoryBot.define do
  factory :game do
    system
    master { create(:user) }
    name { FFaker::Product.product_name }

    trait :close do
      open { false }
    end
  end
end
