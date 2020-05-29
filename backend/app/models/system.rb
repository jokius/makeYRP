# frozen_string_literal: true

# == Schema Information
#
# Table name: systems
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  key        :string           not null
#  version    :string           not null
#  template   :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class System < ApplicationRecord
  has_many :games
end
