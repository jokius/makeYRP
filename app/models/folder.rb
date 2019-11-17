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

class Folder < ApplicationRecord
  acts_as_nested_set

  has_many :files, class_name: 'FolderFile', dependent: :destroy

  belongs_to :user
end
