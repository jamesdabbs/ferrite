module Slack
  class Message
    @@deliveries = []

    def self.deliveries
      @@deliveries
    end

    attr_reader :to, :body

    def initialize to:, body:
      @to, @body = to, body
    end

    def team
      to.team
    end

    def username
      to.username
    end

    def deliver
      if Rails.env.test?
        Message.deliveries.push self
      else
        notifier = Notifier.new team.webhook_url, username: "Ferrite"
        notifier.ping body, channel: "@#{username}"
      end
    end
  end
end
