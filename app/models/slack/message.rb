module Slack
  class Message
    @@deliveries = []

    def self.deliveries
      @@deliveries
    end

    attr_reader :to, :team, :channel, :body

    def initialize to:, body:
      @to, @body = to, body

      case @to
      when Slack::TeamMembership
        @team, @channel = @to.team, "@#{@to.username}"
      when Course
        @team, @channel = @to.slack_team, "##{@to.slack_room}"
      else
        raise "Don't know how to Slack #{@to}"
      end
    end

    def deliver
      if Rails.env.test?
        Message.deliveries.push self
      else
        notifier = Notifier.new @team.webhook_url, username: "Ferrite"
        notifier.ping body, channel: @channel
      end
    end
  end
end
