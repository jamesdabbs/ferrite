FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@gmail.com" }

    trait :instructor do |user|
      employment
    end
  end
end
