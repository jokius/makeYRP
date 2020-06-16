# frozen_string_literal: true

# == Schema Information
#
# Table name: systems
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  key        :string           not null
#  version    :string           not null
#  template   :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :system do
    name { FFaker::Product.product_name }
    version { 1 }
    key { 'test_system' }
    template do
      {
        template: {
          sheets: {
            test_actor: { test: 'test_attr' }
          }
        }
      }
    end

    trait :with_menu do
      template do
        {
          template: {
            sheets: {
              test_actor: { test: 'test_attr' }
            },
            menus: [
              {
                type: 'test_menu',
                name: 'test_menu'
              }
            ]
          }
        }
      end
    end

    trait :with_items do
      template do
        {
          template: {
            sheets: {
              test_actor: { test: 'test_attr' }
            },
            items: [
              {
                type: 'base',
                name: 'test_item',
                description: 'test_description'
              }
            ]
          }
        }
      end
    end
  end
end
