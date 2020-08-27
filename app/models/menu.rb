# frozen_string_literal: true

# == Schema Information
#
# Table name: menus
#
#  id         :bigint           not null, primary key
#  identifier :string           not null
#  params     :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint           not null
#
# Indexes
#
#  index_menus_on_game_id  (game_id)
#

class Menu < ApplicationRecord
  belongs_to :game
  has_many :folders, class_name: 'Menus::ItemFolder', dependent: :destroy

  after_create :create_root_folder

  def create_root_folder
    folders.create(name: 'Корневая папка', owner: game.master)
  end
end
