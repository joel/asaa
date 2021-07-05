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

if ENV["CAPYBARA_SERVER_HOST"]
  # Use `fetch` to fail loudly if these variables aren't set. We might relax this
  # and set defaults at some point, but for the moment we want to make sure we didn't
  # miss a step.
  Capybara.server_host = ENV.fetch("CAPYBARA_SERVER_HOST")
  Capybara.server_port = ENV.fetch("CAPYBARA_SERVER_PORT")
end

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
