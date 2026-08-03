ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
  end
end

class ActionDispatch::IntegrationTest
  def sign_in_as(user)
    post dev_login_url(user)
  end
end
