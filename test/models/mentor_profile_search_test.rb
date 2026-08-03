require "test_helper"

class MentorProfileSearchTest < ActiveSupport::TestCase
  setup do
    skill = Skill.create!(name: "Ruby on Rails", slug: "ruby-on-rails")
    user = User.create!(firebase_uid: "m1", email: "m1@test.dev", name: "Ada Rails", role: :mentor)
    @profile = MentorProfile.create!(user: user, headline: "Hotwire expert", hourly_rate_cents: 5000, bio: "Turbo love", active: true)
    @profile.skills << skill
  end

  test "search by query" do
    results = MentorProfile.search(q: "Hotwire")
    assert_includes results, @profile
  end

  test "search by skill slug" do
    results = MentorProfile.search(skill: "ruby-on-rails")
    assert_includes results, @profile
  end

  test "search by max price" do
    results = MentorProfile.search(max_price_cents: 4000)
    assert_not_includes results.to_a, @profile
  end
end
