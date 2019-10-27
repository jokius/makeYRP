# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.unique.email }
    nickname { FFaker::Internet.unique.user_name }
  end
end
