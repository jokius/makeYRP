# frozen_string_literal: true

# == Schema Information
#
# Table name: media
#
#  id         :bigint           not null, primary key
#  key        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Medium < ApplicationRecord
  has_one_attached :image, dependent: :purge

  validates :key, uniqueness: true
end
