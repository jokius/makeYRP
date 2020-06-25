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
      data = { sheet_id: sheet.id, params: { x: 1, y: 1 }, 'type' => 'token' }
      allow(channel).to receive(:broadcast_to).with(page, new: true, token: kind_of(TokenSerializer))

      subscription.add(data)
      expect(subscription).to have_stream_for(page)

      token = Token.find_by(page: page, sheet: sheet)
      expect(token).not_to be_nil
    end

    it 'image' do
      data = { params: { x: 1, y: 1 }, 'type' => 'image' }
      allow(channel).to receive(:broadcast_to).with(page, new: true, image: kind_of(ImageSerializer))

      subscription.add(data)
      expect(subscription).to have_stream_for(page)

      image = Image.find_by(page: page)
      expect(image).not_to be_nil
    end

    it 'graphic' do
      data = { page_id: page.id, kind: 'line', params: { text: :params }, 'type' => 'graphic' }
      allow(channel).to receive(:broadcast_to).with(page, new: true, graphic: kind_of(GraphicSerializer))

      subscription.add(data)
      expect(subscription).to have_stream_for(page)

      graphic = Graphic.find_by(page: page)
      expect(graphic).not_to be_nil
    end

    it 'errors' do
      allow(channel).to receive(:broadcast_to).with(page, errors: anything)
      subscription.add({})
    end
  end

  describe '#change' do
    it 'token' do
      token = create(:token)
      data = { id: token.id, params: { x: 2, y: 3 }, 'type' => 'token' }
      allow(channel).to receive(:broadcast_to).with(page, update: true, token: kind_of(TokenSerializer))

      subscription.change(data)
      expect(subscription).to have_stream_for(page)

      token = token.reload
      expect(token.params['x']).to eq 2
      expect(token.params['y']).to eq 3
    end

    it 'image' do
      image = create(:image)
      data = { id: image.id, params: { x: 2, y: 3 }, 'type' => 'image' }
      allow(channel).to receive(:broadcast_to).with(page, update: true, image: kind_of(ImageSerializer))

      subscription.change(data)
      expect(subscription).to have_stream_for(page)

      image = image.reload
      expect(image.params['x']).to eq 2
      expect(image.params['y']).to eq 3
    end

    it 'graphic' do
      graphic = create(:graphic)
      new_text = 'new text'
      data = { id: graphic.id, params: { text: new_text }, 'type' => 'graphic' }
      allow(channel).to receive(:broadcast_to).with(page, update: true, graphic: kind_of(GraphicSerializer))

      subscription.change(data)
      expect(subscription).to have_stream_for(page)

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
      token = create(:token)
      data = { 'id' => token.id, 'type' => 'token' }
      allow(channel).to receive(:broadcast_to).with(page, delete: true, token: { id: token.id })

      subscription.remove(data)
      expect(subscription).to have_stream_for(page)

      expect(Token.find_by(id: data['id'])).to be_nil
    end

    it 'image' do
      image = create(:image)
      data = { 'id' => image.id, 'type' => 'image' }
      allow(channel).to receive(:broadcast_to).with(page, delete: true, image: { id: image.id })

      subscription.remove(data)
      expect(subscription).to have_stream_for(page)

      expect(Image.find_by(id: data['id'])).to be_nil
    end

    it 'graphic' do
      graphic = create(:graphic)
      data = { 'id' => graphic.id, 'type' => 'graphic' }
      allow(channel).to receive(:broadcast_to).with(page, delete: true, graphic: { id: graphic.id })

      subscription.remove(data)
      expect(subscription).to have_stream_for(page)

      expect(Graphic.find_by(id: data['id'])).to be_nil
    end

    it 'errors' do
      allow(channel).to receive(:broadcast_to).with(page, errors: anything)
      subscription.remove({})
    end
  end
end
