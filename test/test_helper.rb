ENV['RAILS_ENV'] ||= 'test'

if ENV["CI"]
  require 'coveralls'
  Coveralls.wear!
else
  require 'simplecov'
  SimpleCov.start 'rails'
end


require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

require 'webmock/minitest'
WebMock.disable_net_connect! allow_localhost: true


begin
  DatabaseCleaner.start
  FactoryGirl.lint
ensure
  DatabaseCleaner.clean
end


Capybara.add_selector(:link_to) do
  xpath { |href| ".//a[@href='#{href}']" }
end


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  include Warden::Test::Helpers
  Warden.test_mode!

  include Capybara::DSL

  def login user
    raise "No user provided" unless user
    raise "`user` is a #{user.class}" unless user.is_a?(User)
    login_as user, scope: :user
  end

  def last_slack_message
    Slack::Message.deliveries.last
  end
end
