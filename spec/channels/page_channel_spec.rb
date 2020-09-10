# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PageChannel, type: :channel do
  let(:channel) { class_double(described_class).as_stubbed_const(transfer_nested_constants: true) }
  let(:user) { create(:user) }
  let(:page) { create(:page) }

  before do
    stub_connection current_user: user
    subscribe(page_id: page.id)
  end

  it '#subscribe' do
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_for(page)
  end

  describe '#add' do
    it 'token' do
      sheet = create(:sheet)
      params = { sheet_id: sheet.id, params: { x: 1, y: 1 }, 'type' => 'token' }
      expect { subscription.add(params) }.to(have_broadcasted_to(page).with do |data|
        expect(data[:token]).to match_json_schema('pages/tokens/show')
        expect(data[:new]).to be true
        expect(Token.find_by(page: page, sheet: sheet, id: data[:token]['data']['id'])).not_to be_nil
      end)
    end

    it 'image' do
      params = { params: { x: 1, y: 1 }, 'type' => 'image' }
      expect { subscription.add(params) }.to(have_broadcasted_to(page).with do |data|
        expect(data[:image]).to match_json_schema('pages/images/show')
        expect(data[:new]).to be true
        expect(Image.find_by(page: page, id: data[:image]['data']['id'])).not_to be_nil
      end)
    end

    it 'graphic' do
      params = { page_id: page.id, kind: 'line', params: { text: :params }, 'type' => 'graphic' }
      expect { subscription.add(params) }.to(have_broadcasted_to(page).with do |data|
        expect(data[:graphic]).to match_json_schema('pages/graphic/show')
        expect(data[:new]).to be true
        expect(Graphic.find_by(page: page, id: data[:graphic]['data']['id'])).not_to be_nil
      end)
    end

    it 'errors' do
      allow(channel).to receive(:broadcast_to).with(page, errors: anything)
      subscription.add({})
    end
  end

  describe '#change' do
    it 'token' do
      sheet = create(:sheet, owner: user)
      token = create(:token, sheet: sheet)
      params = { 'id' => token.id, params: { x: 2, y: 3 }, 'type' => 'token' }
      expect { subscription.change(params) }.to(have_broadcasted_to(page).with do |data|
        expect(data[:token]).to match_json_schema('pages/tokens/show')
        expect(data[:update]).to be true
        expect(data[:from]).to eq user.id.to_s
      end)

      token = token.reload
      expect(token.params['x']).to eq 2
      expect(token.params['y']).to eq 3
    end

    it 'image' do
      image = create(:image, owner: user)
      params = { 'id' => image.id, params: { x: 2, y: 3 }, 'type' => 'image' }
      expect { subscription.change(params) }.to(have_broadcasted_to(page).with do |data|
        expect(data[:image]).to match_json_schema('pages/images/show')
        expect(data[:update]).to be true
        expect(data[:from]).to eq user.id.to_s
      end)

      image = image.reload
      expect(image.params['x']).to eq 2
      expect(image.params['y']).to eq 3
    end

    it 'graphic' do
      graphic = create(:graphic, owner: user)
      new_text = 'new text'
      params = { 'id' => graphic.id, params: { text: new_text }, 'type' => 'graphic' }
      expect { subscription.change(params) }.to(have_broadcasted_to(page).with do |data|
        expect(data[:graphic]).to match_json_schema('pages/graphic/show')
        expect(data[:update]).to be true
        expect(data[:from]).to eq user.id.to_s
      end)

      graphic = graphic.reload
      expect(graphic.params['text']).to eq new_text
    end

    it 'errors' do
      allow(channel).to receive(:broadcast_to).with(page, errors: anything)
      subscription.change({})
    end
  end

  describe '#remove' do
    it 'token' do
      sheet = create(:sheet, owner: user)
      token = create(:token, sheet: sheet)
      params = { 'id' => token.id, 'type' => 'token' }
      expect { subscription.remove(params) }.to(have_broadcasted_to(page).with do |data|
        expect(data[:id]).to eq token.id
        expect(data[:token]).to be true
        expect(data[:delete]).to be true
      end)

      expect(Token.find_by(id: params['id'])).to be_nil
    end

    it 'image' do
      image = create(:image, owner: user)
      params = { 'id' => image.id, 'type' => 'image' }
      expect { subscription.remove(params) }.to(have_broadcasted_to(page).with do |data|
        expect(data[:id]).to eq image.id
        expect(data[:image]).to be true
        expect(data[:delete]).to be true
      end)

      expect(Image.find_by(id: params['id'])).to be_nil
    end

    it 'graphic' do
      graphic = create(:graphic, owner: user)
      params = { 'id' => graphic.id, 'type' => 'graphic' }
      expect { subscription.remove(params) }.to(have_broadcasted_to(page).with do |data|
        expect(data[:id]).to eq graphic.id
        expect(data[:graphic]).to be true
        expect(data[:delete]).to be true
      end)

      expect(Graphic.find_by(id: params['id'])).to be_nil
    end

    it 'errors' do
      allow(channel).to receive(:broadcast_to).with(page, errors: anything)
      subscription.remove({})
    end
  end
end
