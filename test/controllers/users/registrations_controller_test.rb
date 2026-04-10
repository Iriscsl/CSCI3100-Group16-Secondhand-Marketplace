require "test_helper"

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new registration form" do
    get new_user_registration_path
    assert_response :success
    assert_select "form", true
  end

  test "should create new user with valid params" do
    assert_difference("User.count", 1) do
      post user_registration_path, params: {
        user: {
          name: "New Student",
          email: "1155999999@link.cuhk.edu.hk",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
  end

  test "should not create user with invalid email format" do
    assert_no_difference("User.count") do
      post user_registration_path, params: {
        user: {
          name: "New Student",
          email: "invalid@gmail.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should not create user with missing name" do
    assert_no_difference("User.count") do
      post user_registration_path, params: {
        user: {
          name: "",
          email: "1155999999@link.cuhk.edu.hk",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should not create user with short password" do
    assert_no_difference("User.count") do
      post user_registration_path, params: {
        user: {
          name: "New Student",
          email: "1155999999@link.cuhk.edu.hk",
          password: "short",
          password_confirmation: "short"
        }
      }
    end
    assert_response :unprocessable_entity
  end
end
