# == Schema Information
#
# Table name: custom_systems
#
#  id         :bigint           not null, primary key
#  game_id    :bigint           not null
#  template   :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :custom_system do
    
  end
end
