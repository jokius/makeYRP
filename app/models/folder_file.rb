# frozen_string_literal: true

# == Schema Information
#
# Table name: folder_files
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  folder_id  :bigint           not null
#
# Indexes
#
#  index_folder_files_on_folder_id  (folder_id)
#

class FolderFile < ApplicationRecord
  extend Images

  belongs_to :folder
  has_one_attached :image, dependent: :purge
  images_version :image
end
