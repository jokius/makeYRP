# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean          default(FALSE), not null
#  color                  :string           not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  jti                    :string           not null
#  nickname               :string           not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_jti                   (jti) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
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
