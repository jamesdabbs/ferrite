FactoryGirl.define do
  factory :submission do
    assignment
    user
    repo     "rails"
    comfort  { rand(1..5) }
    comments { Faker::Lorem.paragraph }
  end
end
