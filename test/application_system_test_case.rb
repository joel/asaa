# frozen_string_literal: true

require "test_helper"
require "socket"
class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # http://chromedriver.chromium.org/capabilities

  if ENV["CAPYBARA_SERVER_HOST"]
    driven_by :selenium, using: :chrome, screen_size: [1400, 1400],
                        options: {
                          browser: :remote,
                          url: "http://host.docker.internal:9515",
                        }
  elsif ENV["SELENIUM_REMOTE_HOST"]
    # url = "http://#{ENV['SELENIUM_REMOTE_HOST']}:4444/wd/hub"
    driven_by :selenium, using: :chrome, options: {
      browser: :remote,
      url: "http://#{IPSocket.getaddress(Socket.gethostname)}",
      desired_capabilities: :chrome }
  elsif ENV["CHROME_HEADLESS"]
    driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400], options: { url: ENV.fetch("HUB_URL") }
    Capybara.always_include_port = true
  else
    driven_by :selenium, using: :chrome do |driver_options|
      driver_options.add_argument("--no-sandbox")
      driver_options.add_argument("--disable-dev-shm-usage")
      driver_options.add_argument("--disable-gpu")
      driver_options.add_argument("--window-size=1400,1400")
    end
  end
end
