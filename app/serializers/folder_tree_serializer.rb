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

class FolderTreeSerializer < BaseSerializer
  attributes :name, :parent_id
  attribute :images do |folder|
    folder.files.with_attached_image.map do |image|
      FolderImageSerializer.new(image)
    end
  end

  attribute :children do |folder|
    folder.children.map do |item|
      FolderTreeSerializer.new(item)
    end
  end
end

