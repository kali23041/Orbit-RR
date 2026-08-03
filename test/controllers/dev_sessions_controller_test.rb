require "test_helper"

class DevSessionsControllerTest < ActionDispatch::IntegrationTest
  test "dev login signs in user" do
    user = User.create!(firebase_uid: "dev1", email: "dev1@test.dev", name: "Dev One")
    post dev_login_url(user)
    assert_redirected_to dashboard_url
    follow_redirect!
    assert_match(/Dev One/, response.body)
  end
end
