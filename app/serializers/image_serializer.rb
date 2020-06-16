# frozen_string_literal: true

# == Schema Information
#
# Table name: images
#
#  id         :bigint           not null, primary key
#  page_id    :bigint           not null
#  params     :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ImageSerializer < ActiveModel::Serializer
  attributes :id, :page_id, :params
end
