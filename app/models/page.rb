# frozen_string_literal: true

# == Schema Information
#
# Table name: pages
#
#  id         :bigint           not null, primary key
#  game_id    :bigint           not null
#  name       :string           not null
#  params     :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Page < ApplicationRecord
  belongs_to :game
  has_many :tokens
  has_many :images
  has_many :graphics
end
