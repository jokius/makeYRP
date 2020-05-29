# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SystemPolicy, type: :policy do
  let(:user) { create :user }
  let(:record) { create :system }
  let(:context) { { user: user } }

  describe_rule :new? do
    failed 'when player'

    succeed 'when admin' do
      before { user.admin = true }
    end
  end

  describe_rule :create? do
    failed 'when player'

    succeed 'when admin' do
      before { user.admin = true }
    end
  end
end
