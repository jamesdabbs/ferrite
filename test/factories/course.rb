FactoryGirl.define do
  factory :course do
    topic
    campus
    instructor   { create :employment }
    start_on     { 1.week.from_now }
    organization { Faker::Company.name }

    trait :with_slack_team do |course|
      slack_team
    end
  end
end
