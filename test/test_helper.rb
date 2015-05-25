ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start 'rails'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'


begin
  DatabaseCleaner.start
  FactoryGirl.lint
ensure
  DatabaseCleaner.clean
end


VCR.configure do |c|
  c.cassette_library_dir = "test/cassettes"
  c.hook_into :webmock
end


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  include Warden::Test::Helpers
  Warden.test_mode!

  include Capybara::DSL

  def login user
    login_as user, scope: :user
  end

  def last_slack_message
    Slack::Message.deliveries.last
  end

  def vcr
    VCR.use_cassette method_name, re_record_interval: 7.days do
      yield
    end
  end
end
