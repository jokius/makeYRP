# frozen_string_literal: true

# == Schema Information
#
# Table name: pages
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  params     :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint           not null
#
# Indexes
#
#  index_pages_on_game_id  (game_id)
#

class Page < ApplicationRecord
  belongs_to :game
  has_many :tokens, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :graphics, dependent: :destroy
end
