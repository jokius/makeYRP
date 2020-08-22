# frozen_string_literal: true

# == Schema Information
#
# Table name: sheets
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  params     :jsonb            not null
#  read_all   :boolean          default(FALSE), not null
#  sheet_type :string           not null
#  write_all  :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint           not null
#  owner_id   :bigint           not null
#
# Indexes
#
#  index_sheets_on_game_id               (game_id)
#  index_sheets_on_game_id_and_owner_id  (game_id,owner_id)
#  index_sheets_on_owner_id              (owner_id)
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
