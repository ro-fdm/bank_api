require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  it { should belong_to(:bank) }
  it { should validate_presence_of(:iban) }
end
