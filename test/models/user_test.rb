require "test_helper"

class UserTest < ActiveSupport::TestCase
  # --- CUHK email validation ---

  test "valid CUHK email is accepted" do
    user = User.new(
      email: "1155999999@link.cuhk.edu.hk",
      password: "password",
      password_confirmation: "password"
    )
    assert user.valid?, "Expected user with CUHK email to be valid, got: #{user.errors.full_messages}"
  end

  test "non-CUHK email is rejected" do
    user = User.new(
      email: "test@gmail.com",
      password: "password",
      password_confirmation: "password"
    )
    assert_not user.valid?
    assert_includes user.errors[:email], "must be a CUHK email address (1155xxxxxx@link.cuhk.edu.hk)"
  end

  test "partial CUHK domain is rejected" do
    user = User.new(
      email: "1155111111@cuhk.edu.hk",
      password: "password",
      password_confirmation: "password"
    )
    assert_not user.valid?
    assert_includes user.errors[:email], "must be a CUHK email address (1155xxxxxx@link.cuhk.edu.hk)"
  end

  # --- strip_email_spaces ---

  test "leading and trailing spaces are stripped from email" do
    user = User.new(
      email: "  1155888888@link.cuhk.edu.hk  ",
      password: "password",
      password_confirmation: "password"
    )
    user.valid?
    assert_equal "1155888888@link.cuhk.edu.hk", user.email
  end

  # --- has_many items ---

  test "user has many items" do
    user = users(:one)
    assert_respond_to user, :items
    assert user.items.count >= 1
  end

  test "destroying user destroys associated items" do
    user = users(:one)
    item_count = user.items.count
    assert item_count > 0

    assert_difference("Item.count", -item_count) do
      user.destroy
    end
  end
end
