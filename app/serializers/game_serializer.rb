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

class GameSerializer < ActiveModel::Serializer
  attributes :id, :name
  attribute :template do
    object.system.template
  end

  belongs_to :master, serializer: ShortUserSerializer
  has_many :users, serializer: ShortUserSerializer
  has_many :menus
  has_many :pages
end
