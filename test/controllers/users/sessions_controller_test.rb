require "test_helper"

class Users::SessionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
  end

  test "user can sign in with valid credentials" do
    post user_session_url, params: {
      user: {
        email: @user.email,
        password: "password"
      }
    }
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

  test "sign in fails with wrong password" do
    post user_session_url, params: {
      user: {
        email: @user.email,
        password: "wrongpassword"
      }
    }
    assert_response :unprocessable_entity
  end

  test "user can sign out" do
    sign_in @user
    delete destroy_user_session_url
    assert_response :redirect
  end
end
