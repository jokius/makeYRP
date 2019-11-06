# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Systems::Change, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:file) { file_fixture('system.json') }

  describe 'create new system' do
    let(:input) do
      {
        name: 'test system',
        text: file.read,
        file: nil
      }
    end

    it 'save new system' do
      system = interactor.success
      expect(system.name).to eq input[:name]
      expect(system.template).to eq JSON.parse(input[:text])
    end
  end

  describe 'update system' do
    let!(:system) do
      template = JSON.parse(file.read, symbolize_names: true)
      create(:system, version: 'old_version', key: template[:identifier], template: template)
    end

    let(:input) do
      {
        name: 'test system',
        text: file_fixture('system.json').read,
        file: nil
      }
    end

    it 'update system' do
      updated_system = interactor.success
      expect(updated_system.id).to eq system.id
      expect(updated_system.name).to eq input[:name]
      expect(updated_system.template).to eq JSON.parse(input[:text])
    end
  end

  describe 'not change current version system' do
    let!(:system) do
      template = JSON.parse(file.read, symbolize_names: true)
      create(:system, version: template[:version], key: template[:identifier], template: template)
    end

    let(:input) do
      {
        name: 'new test system',
        text: file_fixture('system.json').read,
        file: nil
      }
    end

    it 'no change system' do
      updated_system = interactor.success
      expect(updated_system.id).to eq system.id
      expect(updated_system.name).not_to eq input[:name]
      expect(updated_system.template).to eq JSON.parse(input[:text])
    end
  end
end
