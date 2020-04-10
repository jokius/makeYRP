# frozen_string_literal: true

# == Schema Information
#
# Table name: access_levels
#
#  id          :bigint           not null, primary key
#  object_type :string           not null
#  object_id   :bigint           not null
#  user_id     :bigint           not null
#  write       :boolean          default(FALSE), not null
#  read        :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :access_level do
    trait(:write) { write { true } }
    trait(:read) { read { true } }
  end
end
