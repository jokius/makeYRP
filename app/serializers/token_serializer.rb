# frozen_string_literal: true

# == Schema Information
#
# Table name: tokens
#
#  id         :bigint           not null, primary key
#  page_id    :bigint           not null
#  sheet_id   :bigint           not null
#  position_x :float            not null
#  position_y :float            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TokenSerializer < ActiveModel::Serializer
  attributes :id, :sheet_id, :position_x, :position_y
end
