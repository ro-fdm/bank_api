FactoryBot.define do
  factory :bank_account do
    iban { Faker::Code.imei }
    association :bank
  end
end