# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"

require_relative "../config/environment"
require "rails/test_help"

Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

require "minitest/autorun"
require "minitest/focus"

require "rr"
RR.debug = true

require "minitest/reporters"
minitest_reporters = Minitest::Reporters::SpecReporter
Minitest::Reporters.use! minitest_reporters.new

if ENV["HUB_URL"]
  Capybara.app_host = "http://#{IPSocket.getaddress(Socket.gethostname)}:3000"
  Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
  Capybara.server_port = 3000
end

# Capybara.app_host = "http://127.0.0.1:#{ENV.fetch("TEST_SERVER_PUBLISHED_PORT")}"
Capybara.server_host = ENV.fetch("CAPYBARA_SERVER_HOST")
Capybara.server_port = ENV.fetch("CAPYBARA_SERVER_PORT")

require "database_cleaner"
require "database_cleaner/active_record"

DatabaseCleaner.strategy = :transaction

module ActiveSupport
  class TestCase
    extend MiniTest::Spec::DSL
    include FactoryBot::Syntax::Methods
    include DatabaseCleanerHook
  end
end
