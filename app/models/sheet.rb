# frozen_string_literal: true

# == Schema Information
#
# Table name: sheets
#
#  id         :bigint           not null, primary key
#  game_id    :bigint           not null
#  owner_id   :bigint           not null
#  read_all   :boolean          default(FALSE), not null
#  write_all  :boolean          default(FALSE), not null
#  name       :string           not null
#  params     :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Sheet < ApplicationRecord
  belongs_to :game
  belongs_to :owner, class_name: 'User'
end
