# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  nickname               :string           not null
#  admin                  :boolean          default(FALSE), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  jti                    :string           not null
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
