# frozen_string_literal: true

# == Schema Information
#
# Table name: graphics
#
#  id         :bigint           not null, primary key
#  page_id    :bigint           not null
#  layer      :string
#  params     :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class GraphicSerializer < ActiveModel::Serializer
  attributes :id, :layer, :params
end
