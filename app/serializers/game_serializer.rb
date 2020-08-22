# frozen_string_literal: true

# == Schema Information
#
# Table name: games
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  open       :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  master_id  :bigint           not null
#  system_id  :bigint           not null
#
# Indexes
#
#  index_games_on_master_id  (master_id)
#  index_games_on_system_id  (system_id)
#

class GameSerializer < ActiveModel::Serializer
  attributes :id, :name, :template

  attribute :system do
    object.system.key.split('-')[0]
  end

  belongs_to :master, serializer: ShortUserSerializer
  has_many :users, serializer: ShortUserSerializer do
    object.users.with_attached_avatar
  end

  has_many :menus
  has_many :pages
end
