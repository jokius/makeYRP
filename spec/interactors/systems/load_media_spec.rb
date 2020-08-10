# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Systems::LoadMedia, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:system) { create(:system) }
  let(:name) { 'test' }
  let(:file_name) { 'test.png' }
  let(:file) { file_fixture('test.png') }
  let(:input) do
    {
      id: system.id,
      name: name,
      file_name: file_name,
      io_file: file.read
    }
  end

  it 'create new media' do
    expect(interactor).to be_success
    result = interactor.success
    expect(result[:key]).to eq "#{system.key}_#{name}"
  end

  describe 'update media' do
    let!(:media) do
      create(:medium, key: "#{system.key}_#{name}")
    end

    it do
      expect(interactor).to be_success
      result = interactor.success
      expect(result[:key]).to eq "#{system.key}_#{name}"
      expect(media.image).to be_attached
    end
  end
end
