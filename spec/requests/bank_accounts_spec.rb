require 'rails_helper'

RSpec.describe 'BankAccounts API', type: :request do 
	# initialize test data
	let(:bank) {FactoryBot.create(:bank) }
	let!(:bank_accounts){ create_list(:bank_account, 10, bank: bank) }
	let(:bank_account_id) { bank_accounts.first.id }

	describe 'GET /bank_accounts/:id' do
		before { get "/bank_accounts/#{bank_account_id}"}

		context 'when bank_account exist' do
			it 'returns the bank_account' do
				expect(json).not_to be_empty
				expect(json['id']).to eq(bank_account_id)
			end

			it 'returns status code 200' do
				expect(response).to have_http_status(200)
			end
		end

 		context 'when the bank_account does not exist' do
      let(:bank_account_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find BankAccount/)
      end
    end
	end

  # Test suite for POST /todos
  describe 'POST /bank_accounts' do
    # valid bank accounts
    let(:ba_attributes) { { iban: '123456789', bank: @bank } }

    context 'when the request is valid' do
      before { post '/bank_accounts', params: ba_attributes }

      it 'creates a bank_account' do
        expect(json['iban']).to eq('123456789')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/bank_accounts', params: { iban: 'Foobar' } }

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