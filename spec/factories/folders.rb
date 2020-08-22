# frozen_string_literal: true

# == Schema Information
#
# Table name: folders
#
#  id             :bigint           not null, primary key
#  children_count :integer          default(0), not null
#  depth          :integer          default(0), not null
#  lft            :integer          not null
#  name           :string
#  rgt            :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  parent_id      :integer
#  user_id        :bigint
#
# Indexes
#
#  index_folders_on_lft        (lft)
#  index_folders_on_parent_id  (parent_id)
#  index_folders_on_rgt        (rgt)
#  index_folders_on_user_id    (user_id)
#

FactoryBot.define do
  factory :folder do
    user
    name { FFaker::Product.product_name }
  end

  trait :with_children do
    after(:create) do |parent|
      create(:folder, parent: parent)
    end
  end

  trait :with_file do
    after(:create) do |folder|
      create(:folder_file, folder: folder)
    end
  end
end
