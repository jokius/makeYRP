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
#  kind       :string
#  read_all   :boolean          default(FALSE), not null
#  write_all  :boolean          default(FALSE), not null
#

class Graphic < ApplicationRecord
  belongs_to :page
end
