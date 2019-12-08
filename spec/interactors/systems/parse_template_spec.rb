# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Systems::ParseTemplate, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  describe 'create new system' do
    let(:file) { file_fixture('system.json') }
    let(:data_file) { file_fixture('system_data.json') }
    let(:template) { JSON.parse(file.read, symbolize_names: true) }
    let(:data) { JSON.parse(data_file.read, symbolize_names: true) }

    context 'when without private data' do
      let(:input) do
        {
          name: 'test system',
          file: file.open,
          data_file: data_file.open,
          private_data_file: 'null'
        }
      end

      it 'save new system' do
        expect(interactor).to be_success
        result = interactor.success
        expect(result[:name]).to eq input[:name]
        expect(result[:template][:identifier]).to eq template[:identifier]
        expect(result[:template][:version]).to eq template[:version]
        expect(result[:template][:public_key]).to eq data[:public_key]
        expect(result[:template][:private_key]).to eq data[:private_key]
        expect(result[:template][:empty_key]).to eq 'empty_key'
      end
    end

    context 'when with private data' do
      let(:private_data_file) { file_fixture('system_private_data.json') }
      let(:private_data) { JSON.parse(private_data_file.read, symbolize_names: true) }

      let(:input) do
        {
          name: 'test system',
          file: file.open,
          data_file: data_file.open,
          private_data_file: private_data_file.open
        }
      end

      it 'save new system' do
        expect(interactor).to be_success
        result = interactor.success
        expect(result[:name]).to eq input[:name]
        expect(result[:template][:identifier]).to eq template[:identifier]
        expect(result[:template][:version]).to eq template[:version]
        expect(result[:template][:public_key]).to eq data[:public_key]
        expect(result[:template][:private_key]).to eq private_data[:private_key]
        expect(result[:template][:empty_key]).to eq 'empty_key'
      end
    end
  end
end
