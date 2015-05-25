FactoryGirl.define do
  factory :project do
    topic
    title       { Faker::Company.catch_phrase }
    description { Faker::Lorem.paragraph }
  end
end
