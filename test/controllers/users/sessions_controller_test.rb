require "test_helper"

class Users::SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    # Create a test user
    @user = User.create!(
      name: "Test User",
      email: "1155123456@link.cuhk.edu.hk",
      password: "password123",
      password_confirmation: "password123",
      confirmed_at: Time.current
    )
  end

  test "should get login form" do
    get new_user_session_path
    assert_response :success
  end

  test "should log in with valid credentials" do
    # Use post directly (integration test handles CSRF automatically)
    post user_session_path, params: {
      user: {
        email: @user.email,
        password: "password123"
      }
    }

    # Should redirect to root path after successful login
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should not log in with invalid password" do
    post user_session_path, params: {
      user: {
        email: @user.email,
        password: "wrongpassword"
      }
    }

    # Should show error and not redirect
    assert_response :unprocessable_entity
  end

  test "should log out successfully" do
    # First log in
    post user_session_path, params: {
      user: {
        email: @user.email,
        password: "password123"
      }
    }

    # Then log out
    delete destroy_user_session_path

    # Should redirect after logout
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should show error with empty email" do
    post user_session_path, params: {
      user: {
        email: "",
        password: "password123"
      }
    }

    assert_response :unprocessable_entity
  end

  test "should show error with empty password" do
    post user_session_path, params: {
      user: {
        email: @user.email,
        password: ""
      }
    }

    assert_response :unprocessable_entity
  end
end
