# frozen_string_literal: true

# == Schema Information
#
# Table name: menus
#
#  id         :bigint           not null, primary key
#  game_id    :bigint           not null
#  name       :string           not null
#  params     :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MenuSerializer < ActiveModel::Serializer
  attributes :id, :name, :params
end
