require 'rails_helper'

RSpec.describe PaymentMethod, type: :model do
  it { should belong_to(:origin) }
  it { should belong_to(:destination) }
  it { validate_presence_of(:amount) }
end
