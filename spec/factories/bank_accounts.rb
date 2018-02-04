FactoryBot.define do
  factory :bank_account do
    iban { Faker::Code.imei }
    balance Faker::Number.number(5)
    association :bank
    association :user
  end
end