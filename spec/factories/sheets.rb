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
#

FactoryBot.define do
  factory :sheet do
    game
    owner { user }
    name { FFaker::Product.product_name }
  end
end
