FactoryGirl.define do
  factory :campus do
    name { Faker::Address.city }
  end
end
