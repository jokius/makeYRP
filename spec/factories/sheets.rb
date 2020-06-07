# frozen_string_literal: true

# == Schema Information
#
# Table name: sheets
#
#  id         :bigint           not null, primary key
#  game_id    :bigint           not null
#  owner_id   :bigint           not null
#  read_all   :boolean          default(FALSE), not null
#  write_all  :boolean          default(FALSE), not null
#  name       :string           not null
#  params     :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sheet_type :string           not null
#

FactoryBot.define do
  factory :sheet do
    game
    owner { create(:user) }
    sheet_type { 'character' }
    name { FFaker::Product.product_name }

    trait :with_acl do
      after(:create) do |sheet|
        create(:access_level, :write, :read, :with_user, object: sheet)
      end
    end
  end
end
