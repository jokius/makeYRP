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

class Token < ApplicationRecord
  belongs_to :page
  belongs_to :sheet
end
