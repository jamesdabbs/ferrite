module Github
  class Error < StandardError; end
  class NotAuthorized < Error; end

  class Organization
    attr_reader :name

    def initialize name
      @name = name
      freeze
    end

    def url
      "//github.com/#{name}"
    end
  end
end
