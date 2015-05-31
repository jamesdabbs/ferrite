FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@gmail.com" }
    name             { Faker::Name.name }
    github_username  "rails" # FIXME: this is a hack to sidestep Github auth errors in test

    trait :instructor do |user|
      employment
    end
  end
end
