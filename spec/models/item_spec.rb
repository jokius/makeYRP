# frozen_string_literal: true

# == Schema Information
#
# Table name: items
#
#  id         :bigint           not null, primary key
#  game_id    :bigint           not null
#  by_system  :boolean          default(FALSE), not null
#  item_type  :string           not null
#  name       :string           not null
#  params     :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Item, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
