# frozen_string_literal: true

# == Schema Information
#
# Table name: images
#
#  id         :bigint           not null, primary key
#  layer      :string           not null
#  params     :jsonb            not null
#  read_all   :boolean          default(TRUE), not null
#  write_all  :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :bigint           not null
#  page_id    :bigint           not null
#
# Indexes
#
#  index_images_on_page_id  (page_id)
#

class ImageSerializer < BaseSerializer
  attributes :params, :layer

  attribute :acl do |item|
    AclSerializer.new(item).to_hash[:data][:attributes]
  end
end
