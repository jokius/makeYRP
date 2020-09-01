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

class GameConfigSerializer < BaseSerializer
  attributes :name, :template

  attribute :system do |game|
    game.system.key.split('-')[0]
  end

  attribute :custom_template do |game|
    game.custom_system.template
  end

  belongs_to :master, serializer: ShortUserSerializer
  has_many :users, serializer: ShortUserSerializer do |game|
    game.users.with_attached_avatar
  end
end
