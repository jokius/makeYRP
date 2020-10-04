# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TokenPolicy, type: :policy do
  let(:user) { create :user }
  let(:game) { create :game }
  let(:sheet) { create(:sheet, game: game) }
  let(:record) { create(:token, sheet: sheet) }
  let(:context) { { user: user } }

  describe_rule :read? do
    failed 'when no access' do
      before { record.update(write_all: false, read_all: false) }
    end

    succeed 'when master' do
      let(:game) { create(:game, master: user) }
    end

    succeed 'when owner' do
      let(:sheet) { create(:sheet, owner: user) }
    end

    succeed 'when write all' do
      before { record.update(write_all: true, read_all: false) }
    end

    succeed 'when read all' do
      before { record.update(read_all: true, write_all: false) }
    end

    succeed 'when write access' do
      before { create(:access_level, :write, object: record, user: user, read: false) }
    end

    succeed 'when read access' do
      before { create(:access_level, :read, object: record, user: user, write: false) }
    end
  end

  describe_rule :write? do
    failed 'when no access'

    succeed 'when master' do
      let(:game) { create(:game, master: user) }
    end

    succeed 'when owner' do
      let(:sheet) { create(:sheet, owner: user) }
    end

    succeed 'when write all' do
      before { record.update(write_all: true, read_all: false) }
    end

    failed 'when read all' do
      before { record.update(read_all: true, write_all: false) }
    end

    succeed 'when write access' do
      before { create(:access_level, :write, object: record, user: user, read: false) }
    end

    failed 'when read access' do
      before { create(:access_level, :read, object: record, user: user, write: false) }
    end
  end

  describe_rule :remove? do
    failed 'when no access'

    succeed 'when master' do
      let(:game) { create(:game, master: user) }
    end

    succeed 'when owner' do
      let(:sheet) { create(:sheet, owner: user) }
    end
  end

  describe_rule :change_access? do
    failed 'when no access'

    succeed 'when master' do
      let(:game) { create(:game, master: user) }
    end

    succeed 'when owner' do
      let(:record) { create(:sheet, owner: user) }
    end
  end
end
