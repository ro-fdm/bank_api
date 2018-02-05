require 'rails_helper'

RSpec.describe Payment, type: :model do
  it { should belong_to(:origin) }
  it { should belong_to(:destination) }
  it { validate_presence_of(:amount) }
  it { should validate_numericality_of(:amount) }
  it { should_not allow_value(0).for(:amount) }
  it { should_not allow_value(-1).for(:amount) }

  describe 'should validate kind' do
    it 'should be invalid if kind is not inclusion' do
      payment = FactoryBot.build(:payment, kind: 'debit')

      expect(payment.save).to be_falsey
      expect(payment).not_to be_valid
    end

    it 'should be valid if kind is inclusion' do
      payment = FactoryBot.build(:payment, kind: 'transfer')

      expect(payment.save).to be_truthy
      expect(payment).to be_valid
    end

    it 'should be valid kind nil' do
      payment = FactoryBot.build(:payment, kind: nil)

      expect(payment.save).to be_truthy
      expect(payment).to be_valid
    end

    it '#payment_service' do
      payment = FactoryBot.build(:payment, kind: 'transfer')

      expect(payment.payment_service).to eq(Transfer)
    end
  end
end
