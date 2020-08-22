# frozen_string_literal: true

# == Schema Information
#
# Table name: access_levels
#
#  id          :bigint           not null, primary key
#  object_type :string           not null
#  read        :boolean          default(FALSE), not null
#  write       :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  object_id   :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_access_levels_on_object_type_and_object_id  (object_type,object_id)
#  index_access_levels_on_user_id                    (user_id)
#

FactoryBot.define do
  factory :access_level do
    trait(:write) { write { true } }
    trait(:read) { read { true } }
    trait(:with_user) do
      user { create(:user) }
    end
  end
end
