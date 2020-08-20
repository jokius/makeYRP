# frozen_string_literal: true

# == Schema Information
#
# Table name: menus
#
#  id         :bigint           not null, primary key
#  game_id    :bigint           not null
#  params     :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  identifier :string           not null
#

class Menu < ApplicationRecord
  belongs_to :game
  has_many :items, class_name: 'Menus::Item', dependent: :destroy
end
