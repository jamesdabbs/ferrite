FactoryGirl.define do
  factory :slack_team_membership, class: Slack::TeamMembership do
    team     { create :slack_team }
    user
    username { Faker::Internet.user_name }
  end
end
