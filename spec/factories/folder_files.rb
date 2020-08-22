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

FactoryBot.define do
  factory :folder_file do
    folder
    name { FFaker::Product.product_name }
    image do
      { io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.png')), filename: 'test.png' }
    end
  end
end
