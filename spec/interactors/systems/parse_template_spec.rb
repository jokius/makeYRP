# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Systems::ParseTemplate, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:file) { file_fixture('system.json') }

  describe 'create new system' do
    context 'when send text' do
      let(:input) do
        {
          name: 'test system',
          text: file.read,
          file: nil
        }
      end

      it 'save new system' do
        result = interactor.success
        expect(result[:name]).to eq input[:name]
        expect(result[:template]).to eq JSON.parse(input[:text], symbolize_names: true)
      end
    end

    context 'when send file' do
      let(:input) do
        {
          name: 'test system',
          text: nil,
          file: file.open
        }
      end

      it 'save new system' do
        result = interactor.success
        expect(result[:name]).to eq input[:name]
        expect(result[:template]).to eq JSON.parse(file.read, symbolize_names: true)
      end
    end
  end
end
