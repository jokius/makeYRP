# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  nickname               :string           not null
#  admin                  :boolean          default(FALSE), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  jti                    :string           not null
#

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.unique.email }
    nickname { FFaker::Internet.unique.user_name }
    password { FFaker::Internet.password }
    avatar do
      { io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.png')), filename: 'test.png' }
    end

    factory :admin, class: 'User' do
      admin { true }
    end
  end
end
