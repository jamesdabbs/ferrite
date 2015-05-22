FactoryGirl.define do
  factory :employment do
    user
    sequence(:email) { |n| "employee#{n}@theironyard.com" }
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name  }
  end
end
