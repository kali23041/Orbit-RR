require "test_helper"

class MentorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    user = User.create!(firebase_uid: "ms", email: "ms@test.dev", name: "Sam", role: :mentor)
    MentorProfile.create!(user: user, headline: "System design coach", hourly_rate_cents: 11000, active: true, bio: "Design")
  end

  test "index succeeds" do
    get mentors_url
    assert_response :success
    assert_match(/Mentors/, response.body)
  end

  test "index filters by query" do
    get mentors_url, params: { q: "System design" }
    assert_response :success
    assert_match(/Sam/, response.body)
  end
end
