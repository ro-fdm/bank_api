require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:user) { build(:user) }
  let(:headers) { valid_headers.except('Authorization') }
  let(:banks){ create_list(:bank, 10) }
  let(:bank){ FactoryBot.create(:bank)}
  let(:valid_attributes) do
    attributes_for(:bank)
  end


  describe 'GET /banks/' do
    context 'when banks' do
      before do
        banks
        get "/api/v1/banks", params: {}, headers: headers
      end

      it 'returns the banks' do
        expect(json).not_to be_empty
        expect(json.size).to eq(10)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when banks does not exist' do
      before { get "/api/v1/banks", params: {}, headers: headers}

      it 'returns json empty' do
        expect(json).to be_empty
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(404)
      end
    end
  end

  # Test suite for POST /todos
  describe 'POST /bank_accounts' do
    # valid bank accounts
    let(:user) { create(:user) }    
    let(:ba_attributes) { 
                          { bank: 
                            { 
                              name: 'Banco de Hierro'
                            } 
                          } 
                        }
    let(:headers) { valid_headers }

    context 'when the request is valid' do
      before do
        user
        post "/api/v1/banks", params: ba_attributes.to_json, headers: headers
      end

      it 'creates a bank' do
        expect(json['name']).to eq('Banco de Hierro')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before do
        user
        post "/api/v1/banks", params: {bank:{ name: '' } }.to_json, headers: headers 
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Balance can't be blank/)
      end
    end
  end

  describe 'GET /banks/:id/payments' do
    let(:user) { create(:user) } 
    let(:bank){ FactoryBot.create(:bank)}
    let(:destination){ FactoryBot.create(:bank_account)}
    let(:origin){ FactoryBot.create(:bank_account, bank: bank, user: user)}
    let(:payments){ create_list(:payment, 5, origin: origin, destination: destination )}
    let(:headers) { valid_headers }

    context 'when payments exist' do
      before do
        payments
        get "/api/v1/banks/#{bank.id}/payments", params: {}, headers: headers
      end

      it 'returns the payments when origin is the bank_account' do
        expect(json).not_to be_empty
        expect(json.size).to eq(5)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when payments does not exist' do
      before do
        get "/api/v1/bank/#{bank.id}/payments", params: {}, headers: headers
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it "returns a empty json" do
        expect(json).to be_empty
      end
    end
  end

end