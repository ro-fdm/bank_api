FactoryBot.define do
	factory :payment_method do
		amount Faker::Number.number(4)
		association :origin, factory: :bank_account
		association :destination, factory: :bank_account
	end
end