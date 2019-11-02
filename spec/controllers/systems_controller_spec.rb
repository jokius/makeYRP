# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SystemsController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in_user(user) }

  describe 'GET #index json' do
    before do
      create(:system)
      get :index, params: { format: :json }
    end

    it 'correct json' do
      expect(response.status).to eq 200
      expect(response).to match_json_schema('systems/index')
    end
  end

  describe 'POST #create json' do
    before do
      post :create,
           params: {
             format: :json,
             name: 'new system',
             text: file_fixture('system.json').read,
             file: nil
           }
    end

    it { expect(response.status).to eq 204 }
    it { expect(System.find_by(name: 'new system')).not_to be_nil }
  end
end
