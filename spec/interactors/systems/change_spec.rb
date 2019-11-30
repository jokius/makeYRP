# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Systems::Change, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:file) { file_fixture('system.json') }
  let(:data_file) { file_fixture('system_data.json') }
  let(:template) { JSON.parse(file.read, symbolize_names: true) }
  let(:data) { JSON.parse(data_file.read, symbolize_names: true) }

  describe 'create new system' do
    let(:input) do
      {
        name: 'test system',
        file: file.open,
        data_file: data_file.open,
        private_data_file: nil
      }
    end

    it 'save new system' do
      expect(interactor).to be_success
      result = interactor.success
      expect(result.name).to eq input[:name]
      expect(result.key).to eq template[:identifier]
      expect(result.version).to eq template[:version].to_s
      expect(result.template['public_key']).to eq data[:public_key]
      expect(result.template['public_key']).to eq data[:private_key]
      expect(result.template['empty_key']).to eq 'empty_key'
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
        file: file.open,
        data_file: data_file.open,
        private_data_file: nil
      }
    end

    it 'update system' do
      expect(interactor).to be_success
      updated_system = interactor.success
      expect(updated_system.id).to eq system.id
      expect(updated_system.name).to eq input[:name]
      expect(updated_system.key).to eq template[:identifier]
      expect(updated_system.version).to eq template[:version].to_s
      expect(updated_system.template['public_key']).to eq data[:public_key]
      expect(updated_system.template['private_key']).to eq data[:private_key]
      expect(updated_system.template['empty_key']).to eq 'empty_key'
    end
  end

  describe 'not change current version system' do
    let!(:system) do
      template = JSON.parse(file.read, symbolize_names: true)
      create(:system, version: template[:version], key: template[:identifier], template: template)
    end

    let(:input) do
      {
        name: 'test system',
        file: file.open,
        data_file: data_file.open,
        private_data_file: nil
      }
    end

    it 'no change system' do
      expect(interactor).to be_success
      updated_system = interactor.success
      expect(updated_system.id).to eq system.id
      expect(updated_system.name).not_to eq input[:name]
      expect(updated_system.template).to eq JSON.parse(file.read)
    end
  end
end
