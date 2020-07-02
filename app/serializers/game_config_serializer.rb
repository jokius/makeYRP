# frozen_string_literal: true

# == Schema Information
#
# Table name: games
#
#  id         :bigint           not null, primary key
#  system_id  :bigint           not null
#  master_id  :bigint           not null
#  name       :string           not null
#  open       :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class GameConfigSerializer < ActiveModel::Serializer
  attributes :id, :name, :template

  attribute :system do
    object.system.key.split('-')[0]
  end

  attribute :custom_template do
    object.custom_system.template
  end
end
