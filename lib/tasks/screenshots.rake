# frozen_string_literal: true

namespace :orbit do
  desc "Capture README screenshots into docs/screenshots (requires Chrome + running server)"
  task screenshots: :environment do
    require "fileutils"
    require "selenium-webdriver"

    out = Rails.root.join("docs/screenshots")
    FileUtils.mkdir_p(out)

    base = ENV.fetch("ORBIT_SCREENSHOT_HOST", "http://127.0.0.1:3000")
    learner = User.find_by!(email: "learner@orbit.dev")
    mentor = User.find_by!(email: "ava@orbit.dev")
    profile = mentor.mentor_profile

    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument("--headless=new")
    options.add_argument("--window-size=1440,900")
    options.add_argument("--disable-gpu")
    options.add_argument("--no-sandbox")

    driver = Selenium::WebDriver.for(:chrome, options: options)

    capture = lambda do |name, path, &before|
      driver.navigate.to("#{base}#{path}")
      before&.call
      sleep 0.8
      driver.save_screenshot(out.join("#{name}.png").to_s)
      puts "wrote docs/screenshots/#{name}.png"
    end

    begin
      capture.call("01-home", "/")
      capture.call("02-mentors", "/mentors")
      capture.call("03-mentor-show", "/mentors/#{profile.id}")

      # Sign in as learner via dev login form post using cookies from a visit
      driver.navigate.to("#{base}/")
      # Use rack-style: hit dev login by executing form
      driver.execute_script(<<~JS, learner.id)
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '/dev_login/' + arguments[0];
        const csrf = document.querySelector('meta[name="csrf-token"]')?.content;
        if (csrf) {
          const input = document.createElement('input');
          input.type = 'hidden'; input.name = 'authenticity_token'; input.value = csrf;
          form.appendChild(input);
        }
        document.body.appendChild(form);
        form.submit();
      JS
      sleep 1.2
      driver.save_screenshot(out.join("04-dashboard.png").to_s)
      puts "wrote docs/screenshots/04-dashboard.png"

      booking = Bookings::Create.call(
        learner: learner,
        slot: profile.availability_slots.open.upcoming.first || profile.availability_slots.create!(
          starts_at: 2.days.from_now,
          ends_at: 2.days.from_now + 45.minutes,
          status: :open
        )
      )

      driver.navigate.to("#{base}/bookings/#{booking.id}")
      sleep 0.8
      driver.save_screenshot(out.join("05-booking.png").to_s)
      puts "wrote docs/screenshots/05-booking.png"

      driver.navigate.to("#{base}/bookings/#{booking.id}/room")
      sleep 0.8
      driver.save_screenshot(out.join("06-live-room.png").to_s)
      puts "wrote docs/screenshots/06-live-room.png"

      # Mentor HQ as Ava
      driver.navigate.to("#{base}/")
      driver.execute_script(<<~JS, mentor.id)
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '/dev_login/' + arguments[0];
        const csrf = document.querySelector('meta[name="csrf-token"]')?.content;
        if (csrf) {
          const input = document.createElement('input');
          input.type = 'hidden'; input.name = 'authenticity_token'; input.value = csrf;
          form.appendChild(input);
        }
        document.body.appendChild(form);
        form.submit();
      JS
      sleep 1.0
      driver.navigate.to("#{base}/mentor/dashboard")
      sleep 0.8
      driver.save_screenshot(out.join("07-mentor-hq.png").to_s)
      puts "wrote docs/screenshots/07-mentor-hq.png"
    ensure
      driver.quit
    end
  end
end
