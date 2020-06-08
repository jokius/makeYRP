# frozen_string_literal: true

# == Schema Information
#
# Table name: folders
#
#  id             :bigint           not null, primary key
#  user_id        :bigint
#  name           :string
#  parent_id      :integer
#  lft            :integer          not null
#  rgt            :integer          not null
#  depth          :integer          default(0), not null
#  children_count :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class FolderTreeSerializer < ActiveModel::Serializer
  attributes :id, :name, :parent_id
  has_many :images, serializer: ImageSerializer do
    object.files.with_attached_image
  end

  attribute :children do
    object.children.map do |item|
      FolderTreeSerializer.new(item).to_h
    end
  end
end
