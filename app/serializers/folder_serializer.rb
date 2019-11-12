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
#  images         :jsonb
#

class FolderSerializer < ActiveModel::Serializer
  attributes :id, :name, :parent_id
  has_many :children, serializer: ShortFolderSerializer
  attribute :images do
    object.images.map do |image|
      { url: image.url, lazy: image.lazy.url, thumb: image.thumb.url }
    end
  end
end
