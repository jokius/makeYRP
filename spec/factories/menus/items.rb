# frozen_string_literal: true

# == Schema Information
#
# Table name: menus_items
#
#  id         :bigint           not null, primary key
#  params     :jsonb            not null
#  read_all   :boolean          default(FALSE), not null
#  write_all  :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  folder_id  :bigint           not null
#  menu_id    :bigint           not null
#  owner_id   :bigint           not null
#
# Indexes
#
#  index_menus_items_on_folder_id              (folder_id)
#  index_menus_items_on_menu_id                (menu_id)
#  index_menus_items_on_menu_id_and_folder_id  (menu_id,folder_id)
#

FactoryBot.define do
  factory :menus_item, class: 'Menus::Item' do
    owner { create(:user) }
    folder { create(:menus_item_folder) }
    menu
  end
end
