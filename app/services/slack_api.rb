class SlackApi
  include HTTParty
  base_uri "https://slack.com/api/"

  def initialize token=nil
    @token = token || Figaro.env.slack_token!
  end

  def request method, data={}
    data[:token] = @token
    method = "/#{method}" unless method.start_with? "/"
    response = self.class.post method, body: data
    raise "Slack request error (#{response.code}) - #{response}" unless response.code == 200
    response
  end

  def user_data
    request("users.list")["members"]
  end
end
