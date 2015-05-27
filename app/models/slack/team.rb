module Slack
  class Team < ActiveRecord::Base
    self.table_name = "slack_teams"

    has_many :memberships, class_name: "Slack::TeamMembership"
    has_many :members, through: :memberships, source: :user

    validates_presence_of :name, :webhook_url
    validates_uniqueness_of :name, :webhook_url

    def membership_for user
      memberships.where(user: user).first!
    end

    def admin_label
      name
    end
  end
end
