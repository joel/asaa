# frozen_string_literal: true

require "test_helper"
require "socket"
class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  if ENV["SELENIUM_HOST"]
    Capybara.register_driver :headless_chrome do |app|
      # http://chromedriver.chromium.org/capabilities
      capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
        chromeOptions: { args: %w[--no-sandbox --headless --disable-gpu --disable-dev-shm-usage --start-maximized
                                  --disable-extensions] }
      )

      puts("REMOTE URL [http://#{ENV["SELENIUM_HOST"]}:#{ENV["SELENIUM_PORT"]}/wd/hub]")

      Capybara::Selenium::Driver.new app,
                                     url: "http://#{ENV["SELENIUM_HOST"]}:#{ENV["SELENIUM_PORT"]}/wd/hub",
                                     browser: :remote,
                                     desired_capabilities: capabilities
    end
    driven_by :headless_chrome
  else
    driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
  end

  setup do
    if ENV["TEST_APP_HOST"]
      Capybara.run_server = false
      Capybara.app_host = "http://#{ENV["TEST_APP_HOST"]}:#{ENV["TEST_APP_PORT"]}"

      puts("APP URL [http://#{ENV["TEST_APP_HOST"]}:#{ENV["TEST_APP_PORT"]}]")
    end
  end
end
