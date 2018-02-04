FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    password 'qwerty'
    email { Faker::Internet.email}
  end
end