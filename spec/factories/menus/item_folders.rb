# frozen_string_literal: true

# == Schema Information
#
# Table name: menus_item_folders
#
#  id             :bigint           not null, primary key
#  children_count :integer          default(0), not null
#  depth          :integer          default(0), not null
#  lft            :integer          not null
#  name           :string
#  rgt            :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  menu_id        :bigint
#  owner_id       :bigint
#  parent_id      :integer
#
# Indexes
#
#  index_menus_item_folders_on_lft        (lft)
#  index_menus_item_folders_on_menu_id    (menu_id)
#  index_menus_item_folders_on_owner_id   (owner_id)
#  index_menus_item_folders_on_parent_id  (parent_id)
#  index_menus_item_folders_on_rgt        (rgt)
#
FactoryBot.define do
  factory :menus_item_folder, class: 'Menus::ItemFolder' do
    name { FFaker::Product.product_name }
    owner { create(:user) }
    menu
  end
end
