# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean          default(FALSE), not null
#  color                  :string           not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  jti                    :string           not null
#  nickname               :string           not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_jti                   (jti) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe '#master?' do
    it 'master' do
      game = create(:game, master: user)
      expect(user.master?(game)).to be true
    end

    it 'player' do
      game = create(:game)
      game.users << user
      expect(user.master?(game)).to be false
    end

    it 'not have game' do
      game = create(:game)
      expect(user.master?(game)).to be false
    end
  end
end
