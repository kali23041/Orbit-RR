require "test_helper"

class UsersFindOrCreateFromFirebaseTest < ActiveSupport::TestCase
  test "creates user from firebase payload" do
    user = Users::FindOrCreateFromFirebase.call(
      "sub" => "firebase-abc",
      "email" => "new@orbit.dev",
      "name" => "New User",
      "picture" => "https://example.com/a.png"
    )
    assert user.persisted?
    assert_equal "firebase-abc", user.firebase_uid
    assert_equal "https://example.com/a.png", user.avatar_url
  end

  test "updates existing user" do
    existing = User.create!(firebase_uid: "firebase-abc", email: "old@orbit.dev", name: "Old")
    user = Users::FindOrCreateFromFirebase.call(
      "sub" => "firebase-abc",
      "email" => "new@orbit.dev",
      "name" => "Updated"
    )
    assert_equal existing.id, user.id
    assert_equal "Updated", user.name
    assert_equal "new@orbit.dev", user.email
  end
end
