# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Systems::LoadMedias, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:system) { create(:system) }
  let(:media_file) { file_fixture('test.zip') }
  let(:input) do
    {
      id: system.id,
      media_file: media_file.open
    }
  end

  it 'extract and create new media' do
    expect(interactor).to be_success
    expect(Medium.last.key).to eq "#{system.key}_test"
  end
end
