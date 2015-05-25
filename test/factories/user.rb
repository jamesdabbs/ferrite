FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@gmail.com" }
    name             { Faker::Name.name }

    trait :instructor do |user|
      employment
    end
  end
end
