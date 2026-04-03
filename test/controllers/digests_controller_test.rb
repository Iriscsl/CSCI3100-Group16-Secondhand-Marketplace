require "test_helper"

class DigestsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
  end

  test "digest requires authentication" do
    get daily_digest_url
    assert_redirected_to new_user_session_path
  end

  test "authenticated user can view digest" do
    sign_in @user
    get daily_digest_url
    assert_response :success
  end
end
