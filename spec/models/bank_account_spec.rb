require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  it { should belong_to(:bank) }
  it { should belong_to(:user)}
  it { should validate_presence_of(:balance) }
  it { should validate_presence_of(:iban) }
  it { should have_many(:origin_payments) }
  it { should have_many(:destination_payments)}
  it { should validate_numericality_of(:balance)}
  it { should_not allow_value(0).for(:balance)}
  it { should_not allow_value(-1).for(:balance)}
end