# frozen_string_literal: true

# == Schema Information
#
# Table name: items
#
#  id         :bigint           not null, primary key
#  game_id    :bigint           not null
#  by_system  :boolean          default(FALSE), not null
#  item_type  :string           not null
#  name       :string           not null
#  params     :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Item < ApplicationRecord
  belongs_to :game
end
