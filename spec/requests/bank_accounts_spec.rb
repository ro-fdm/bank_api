require 'rails_helper'

RSpec.describe 'BankAccounts API', type: :request do 
	# initialize test data
  let(:user) { create(:user) }
	let(:bank) { FactoryBot.create(:bank) }
	let!(:bank_accounts){ create_list(:bank_account, 10, bank: bank, user: user) }
	let(:bank_account_id) { bank_accounts.first.id }
  # authorize request
  let(:headers) { valid_headers }

	describe 'GET /bank_accounts/:id' do
		before { get "/api/v1/banks/#{bank.id}/bank_accounts/#{bank_account_id}", params: {}, headers: headers}

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
    let(:user) { create(:user) }    
    let(:bank) { FactoryBot.create(:bank) }
    let(:ba_attributes) { 
    											{ bank_account: 
    												{ 
    													iban: '123456789',
    													balance: 12345
    												} 
    											} 
    										}
    let(:headers) { valid_headers }

    context 'when the request is valid' do
      before do
      	user
        bank
      	post "/api/v1/banks/#{bank.id}/bank_accounts", params: ba_attributes.to_json, headers: headers
      end

      it 'creates a bank_account' do
        expect(json['iban']).to eq('123456789')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before do
        user
      	bank
				post "/api/v1/banks/#{bank.id}/bank_accounts", params: {bank_account:{ iban: 'Foobar' } }.to_json, headers: headers 
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

  describe 'GET /bank_accounts/:id/origin_payments' do
    let(:user) { create(:user) } 
    let(:destination){ FactoryBot.create(:bank_account)}
    let(:origin){ FactoryBot.create(:bank_account, bank: bank, user: user)}
    let(:payments){ create_list(:payment, 10, origin: origin, destination: destination )}
    let(:headers) { valid_headers }

    context 'when payments exist' do
      before do
        payments
        get "/api/v1/banks/#{bank.id}/bank_accounts/#{origin.id}/payments", params: {}, headers: headers
      end

      it 'returns the payments when origin is the bank_account' do
        expect(json).not_to be_empty
        expect(json.size).to eq(10)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when payments does not exist' do
      before do
        get "/api/v1/banks/#{bank.id}/bank_accounts/#{origin.id}/payments", params: {}, headers: headers
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