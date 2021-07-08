# frozen_string_literal: true

require "test_helper"
require "socket"
class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # http://chromedriver.chromium.org/capabilities

  if ENV['SELENIUM_HUB_URL']
    Capybara.register_driver :headless_chrome do |app|
      Capybara::Selenium::Driver.new app,
        url: ENV['SELENIUM_HUB_URL'],
        browser: :remote,
        desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
          chromeOptions: { args: %w(headless disable-gpu) }
        )
    end

    driven_by :headless_chrome
  end

  setup do
    if ENV['TEST_APP_HOST']
      Capybara.server_port = ENV['TEST_APP_PORT'].to_i
      Capybara.app_host = "http://#{ENV['TEST_APP_HOST']}:#{ENV['TEST_APP_PORT']}"
      Capybara.server_host = '0.0.0.0'
    end
  end

  # if ENV["HUB_URL"]
  #   Capybara.register_driver :chrome_headless do |app|
  #     chrome_capabilities = ::Selenium::WebDriver::Remote::Capabilities
  #                           .chrome("goog:chromeOptions" => { args: %w[
  #                                     no-sandbox headless disable-gpu window-size=1400,1400
  #                                   ] })
  #     Capybara::Selenium::Driver.new(app,
  #                                    browser: :remote,
  #                                    url: ENV["HUB_URL"],
  #                                    desired_capabilities: chrome_capabilities)
  #   end
  #   driven_by :chrome_headless
  # end

  # if ENV["HEADLESS_CHROME_TEST"]
  #   driven_by :selenium, using: :chrome do |driver_options|
  #     driver_options.add_argument("--no-sandbox")
  #     driver_options.add_argument("--disable-dev-shm-usage")
  #     driver_options.add_argument("--disable-gpu")
  #     driver_options.add_argument("--window-size=1400,1400")
  #   end
  # end
end
