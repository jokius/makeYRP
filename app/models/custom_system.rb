# frozen_string_literal: true

# == Schema Information
#
# Table name: custom_systems
#
#  id         :bigint           not null, primary key
#  template   :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint           not null
#
# Indexes
#
#  index_custom_systems_on_game_id  (game_id)
#

class CustomSystem < ApplicationRecord
  belongs_to :game
end
