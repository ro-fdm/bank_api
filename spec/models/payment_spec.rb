require 'rails_helper'

RSpec.describe Payment, type: :model do
  it { should belong_to(:origin) }
  it { should belong_to(:destination) }
  it { validate_presence_of(:amount) }

  describe "should validate kind" do
  	it "should be invalid if kind is not inclusion" do
  		payment = FactoryBot.create(:payment, kind: "debit")
  		
  		expect(payment.save).to be_falsey
  		expect(payment).not_to be_valid
  	end

  	it "should be valid if kind is inclusion" do
  		payment = FactoryBot.create(:payment, kind: "transfer")
  		
  		expect(payment.save).to be_truthy
  		expect(payment).to be_valid
  	end

  end
end
