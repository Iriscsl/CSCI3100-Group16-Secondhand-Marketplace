require "test_helper"

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "sign up with valid CUHK email creates user" do
    assert_difference("User.count") do
      post user_registration_url, params: {
        user: {
          email: "1155777777@link.cuhk.edu.hk",
          password: "password",
          password_confirmation: "password",
          name: "New User"
        }
      }
    end
  end

  test "sign up with non-CUHK email fails" do
    assert_no_difference("User.count") do
      post user_registration_url, params: {
        user: {
          email: "test@gmail.com",
          password: "password",
          password_confirmation: "password",
          name: "Bad Email User"
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "sign up with mismatched passwords fails" do
    assert_no_difference("User.count") do
      post user_registration_url, params: {
        user: {
          email: "1155666666@link.cuhk.edu.hk",
          password: "password",
          password_confirmation: "different"
        }
      }
    end
    assert_response :unprocessable_entity
  end
end
