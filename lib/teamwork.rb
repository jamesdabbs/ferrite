module Teamwork
  TEAMWORK_URL = "https://theironyard.teamwork.com"
  JOURNALS_ID = 135182

  class Error < StandardError ; end
  class AuthenticationError < Error ; end

  def self.sync
    Sync.new Client.new
  end
end
