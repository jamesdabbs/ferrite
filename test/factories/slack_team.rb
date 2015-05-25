FactoryGirl.define do
  factory :slack_team, class: Slack::Team do
    name        { Faker::Company.name }
    webhook_url { Faker::Internet.url }
  end
end
