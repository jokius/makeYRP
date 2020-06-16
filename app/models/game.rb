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

class Game < ApplicationRecord
  belongs_to :system
  belongs_to :master, class_name: 'User'

  has_many :users_in_games, dependent: :destroy
  has_many :users, through: :users_in_games
  has_many :pages
  has_many :menus
  has_many :messages
  has_many :items

  def limit_messages(limit)
    messages.order(created_at: :desc).limit(limit).reverse
  end
end
