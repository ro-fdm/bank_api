require 'rails_helper'

RSpec.describe 'Payments API', type: :request do
  # initialize test data
  let(:user) { create(:user) }
  let(:bank) { FactoryBot.create(:bank) }
  let(:origin_account) { FactoryBot.create(:bank_account, bank: bank) }
  let(:destination_account) { FactoryBot.create(:bank_account, bank: bank) }
  let(:payments) do
    create_list(:payment, 10,
                origin: origin_account,
                destination: destination_account)
  end
  let(:payment_id) { payments.first.id }
  # authorize request
  let(:headers) { valid_headers }

  describe 'GET /payments/:id' do
    before do
      get "/api/v1/payments/#{payment_id}", params: {}, headers: headers
    end

    context 'when payment exist' do
      it 'returns the payment' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(payment_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when payment does not exist' do
      let(:payment_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Payment/)
      end
    end
  end

  # Test suite for POST /todos
  describe 'POST /payments' do
    # valid bank accounts
    let(:user) { create(:user) }
    let(:payment_attributes) do
      { payment:
                                  { amount: 12_345,
                                    origin_id: origin_account.id,
                                    destination_id: destination_account.id } }
    end
    let(:payment_attributes_with_valid_kind) do
      { payment:
                                                { amount: 12_345,
                                                  origin_id: origin_account.id,
                                                  destination_id: destination_account.id,
                                                  kind: 'transfer' } }
    end
    let(:payment_attributes_with_no_valid_kind) do
      { payment:
                                                  { amount: 12_345,
                                                    origin_id: origin_account.id,
                                                    destination_id: destination_account.id,
                                                    kind: 'debit' } }
    end

    # authorize request
    let(:headers) { valid_headers }

    context 'when the request is valid' do
      before do
        post '/api/v1/payments', params: payment_attributes.to_json, headers: headers
      end

      it 'creates a payment' do
        expect(json['amount']).to eq(12_345)
        expect(json['transfer']).to be_nil
        expect(json['origin']['id']).to be(origin_account.id)
        expect(json['destination']['id']).to be(destination_account.id)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before do
        bank
        post '/api/v1/payments', params: { payment: { amount: '12345' } }.to_json, headers: headers
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Origin must exist/)
        expect(response.body)
          .to match(/Destination must exist/)
      end
    end

    context 'when the payment kind is valid' do
      before do
        post '/api/v1/payments', params: payment_attributes_with_valid_kind.to_json, headers: headers
      end

      it 'creates a payment' do
        expect(json['amount']).to eq(12_345)
        expect(json['kind']).to eq('transfer')
        expect(json['status']).to eq('OK')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the payment kind is invalid' do
      before do
        post '/api/v1/payments', params: payment_attributes_with_no_valid_kind.to_json, headers: headers
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Kind is not included in the list/)
      end
    end

    context 'when the payment service fail' do
      before do
        payment_attributes_with_valid_kind
        origin_account.update_columns(balance: 0)
        post '/api/v1/payments', params: payment_attributes_with_valid_kind.to_json, headers: headers
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Balance must be greater than 0/)
      end
    end
  end
end
