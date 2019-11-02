# frozen_string_literal: true
# == Schema Information
#
# Table name: games
#
#  id         :bigint           not null, primary key
#  system_id  :bigint           not null
#  master_id  :bigint           not null
#  name       :string           not null
#  open       :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# frozen_string_literal: true

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
