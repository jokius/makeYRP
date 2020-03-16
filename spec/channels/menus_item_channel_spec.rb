# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MenusItemChannel, type: :channel do
  let(:channel) { class_double(described_class).as_stubbed_const(transfer_nested_constants: true) }
  let(:user) { create(:user) }
  let(:item) { create(:menus_item) }

  before do
    stub_connection current_user: user
    subscribe(item_id: item.id)
  end

  it '#subscribe' do
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_for(item)
  end

  describe '#change' do
    let(:params) { { 'new_params' => 'updated' } }

    it 'broadcasted to item' do
      expect { subscription.change(params) }.to(have_broadcasted_to(item).with do |data|
        expect(data).to match_json_schema('games/menus/items/show')
      end)
    end

    it 'new params save' do
      subscription.change(params)
      item.reload
      expect(item.params).to eq params
    end

    it 'errors' do
      allow(channel).to receive(:broadcast_to).with(item, errors: anything)
      subscription.change({})
    end
  end

  describe '#remove' do
    it 'broadcasted to item' do
      expect { subscription.remove }.to(have_broadcasted_to(item).with do |data|
        expect(data[:delete][:id]).to eq item.id
        expect(data[:delete][:menu_id]).to eq item.menu_id
      end)
    end

    it 'remove record' do
      subscription.remove
      expect(Menus::Item.find_by(id: item.id)).to be_nil
    end
  end
end
