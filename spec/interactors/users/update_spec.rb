# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Update, type: :interactor do
  subject(:interactor) { described_class.new.call(input) }

  let(:user) { create(:user, avatar: nil) }

  let(:input) do
    { id: user.id,
      nickname: 'super name',
      color: '#fff',
      avatar: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test.png'), 'image/png')
    }
  end

  it { expect(interactor).to be_success }

  it 'update user' do
    user = interactor.success
    expect(user.nickname).to eq input[:nickname]
    expect(user.color).to eq input[:color]
    expect(user.avatar).to be_attached
  end
end
