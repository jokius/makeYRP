# frozen_string_literal: true

# == Schema Information
#
# Table name: menus_items
#
#  id         :bigint           not null, primary key
#  menu_id    :bigint           not null
#  params     :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :menus_item, class: 'Menus::Item' do
  end
end
