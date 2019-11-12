# frozen_string_literal: true

# == Schema Information
#
# Table name: folders
#
#  id             :bigint           not null, primary key
#  user_id        :bigint
#  name           :string
#  parent_id      :integer
#  lft            :integer          not null
#  rgt            :integer          not null
#  depth          :integer          default(0), not null
#  children_count :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  images         :jsonb
#

FactoryBot.define do
  factory :folder do
    user
    name { FFaker::Product.product_name }
    images { [File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.png'))] }
  end

  trait :with_children do
    after(:create) do |parent|
      create(:folder, parent: parent)
    end
  end
end
