require 'rails_helper'

RSpec.describe Bank, type: :model do
  it { should have_many(:bank_accounts) }
  it { should validate_presence_of(:name) }
end
