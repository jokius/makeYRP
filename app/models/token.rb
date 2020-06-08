# frozen_string_literal: true

# == Schema Information
#
# Table name: tokens
#
#  id         :bigint           not null, primary key
#  page_id    :bigint           not null
#  sheet_id   :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  params     :jsonb            not null
#

class Token < ApplicationRecord
  include Acl

  belongs_to :page
  belongs_to :sheet

  delegate :owner, :owner_id, :game, to: :sheet
end
