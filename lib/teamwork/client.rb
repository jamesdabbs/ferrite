module Teamwork
  class Client
    include HTTParty

    base_uri "#{TEAMWORK_URL}/projects/#{JOURNALS_ID}"
    headers "Accept" => "application/json", "Content-Type" => "application/json"

    def initialize
      @auth = { username: Figaro.env.teamwork_api_token!, password: "" }
    end

    def inspect
      "#<Teamwork::Client:#{object_id}>"
    end

    def authenticate!
      response = get ""
      if [401, 403].include? response.code
        raise AuthenticationError, response["MESSAGE"]
      elsif response.code != 200
        raise Error, response["MESSAGE"]
      end
      true
    end

    def authors
      get("/people").fetch("people")
    end

    def categories
      get("/messageCategories").fetch("categories")
    end

    def journals
      paged("/messages") { |p| p.fetch("posts") }
    end

private

    def get endpoint, opts={}
      opts[:basic_auth] = @auth
      self.class.get "#{endpoint}.json", opts
    end

    def paged endpoint
      response = get endpoint
      contents = yield response
      2.upto response.headers["x-pages"].to_i do |n|
        response  = get endpoint, query: { page: n }
        contents += yield response
      end
      contents
    end
  end
end
