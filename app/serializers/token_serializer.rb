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
#  read_all   :boolean          default(FALSE), not null
#  write_all  :boolean          default(FALSE), not null
#

class TokenSerializer < ActiveModel::Serializer
  attributes :id, :sheet_id, :params

  attribute :acl do
    AclSerializer.new(object)
  end
end
