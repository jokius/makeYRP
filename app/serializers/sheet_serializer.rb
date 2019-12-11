# frozen_string_literal: true

# == Schema Information
#
# Table name: sheets
#
#  id         :bigint           not null, primary key
#  game_id    :bigint           not null
#  owner_id   :bigint           not null
#  read_all   :boolean          default(FALSE), not null
#  write_all  :boolean          default(FALSE), not null
#  name       :string           not null
#  params     :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sheet_type :string           not null
#

class SheetSerializer < ActiveModel::Serializer
  attributes :id, :name, :sheet_type, :params
end
