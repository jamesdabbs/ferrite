FactoryGirl.define do
  factory :topic do
    title { Faker::Company.catch_phrase }
  end
end
