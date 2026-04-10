require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      name: "Test Student",
      email: "1155123456@link.cuhk.edu.hk",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  test "should be valid with valid attributes" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "email should be valid with CUHK Link format" do
    valid_emails = [
      "1155123456@link.cuhk.edu.hk",
      "1155987654@link.cuhk.edu.hk"
    ]
    valid_emails.each do |email|
      @user.email = email
      assert @user.valid?, "#{email} should be valid"
    end
  end

  test "email should reject invalid formats" do
    invalid_emails = [
      "test@gmail.com",
      "1155123456@cuhk.edu.hk",
      "invalid",
      "1155123456@link.cuhk.edu"
    ]
    invalid_emails.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email} should be invalid"
    end
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should have minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "password should be at least 6 characters" do
    @user.password = @user.password_confirmation = "a" * 6
    assert @user.valid?
  end
end
