require 'rails_helper'

RSpec.describe 'Payments API', type: :request do 
	# initialize test data
	let(:bank) {FactoryBot.create(:bank) }
	let(:origin_account){ FactoryBot.create(:bank_account, bank: bank) }
	let(:destination_account) { FactoryBot.create(:bank_account, bank: bank) }
  let(:payments){ create_list(:payment_method, 10, 
                                        origin: origin_account,
                                        destination_account: destination_account )}
  let(:payment_id) { payment_methods.first.id}

  describe 'GET /payments' do
    before { get '/payments' }

    it 'returns payments' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

	describe 'GET /payments/:id' do
		before { get "/payments/#{payment_id}"}

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
        expect(response.body).to match(/Couldn't find BankAccount/)
      end
    end
	end

  # Test suite for POST /todos
  describe 'POST /payments' do
    # valid bank accounts
    let(:payment_attributes) { { amount: 12345, 
                                 origin: origin_account,
                                 destination: destination_account } }

    context 'when the request is valid' do
      before { post '/payments', params: payment_attributes }

      it 'creates a payment' do
        expect(json['amount']).to eq('12345')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/payments', params: { amount: '12345' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Created by can't be blank/)
      end
    end
  end

end