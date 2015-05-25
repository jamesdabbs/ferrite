module Slack
  class TeamMembership < ActiveRecord::Base
    self.table_name = "slack_team_memberships"

    belongs_to :user
    belongs_to :team, class_name: "Slack::Team"

    validates_presence_of :user, :team, :username
    validates_uniqueness_of :username, scope: :team
  end
end
