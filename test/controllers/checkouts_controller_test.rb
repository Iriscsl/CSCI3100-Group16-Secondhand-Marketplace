require "test_helper"

class CheckoutsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @item = items(:one)
  end

  # --- Authentication ---

  test "create requires authentication" do
    post checkout_url, params: { item_id: @item.id }
    assert_redirected_to new_user_session_path
  end

  test "success requires authentication" do
    get checkout_success_url(item_id: @item.id)
    assert_redirected_to new_user_session_path
  end

  test "cancel requires authentication" do
    get checkout_cancel_url(item_id: @item.id)
    assert_redirected_to new_user_session_path
  end

  # --- Checkout success action ---

  test "success marks item as sold" do
    sign_in @user
    assert @item.available?

    get checkout_success_url(item_id: @item.id)
    assert_response :success

    @item.reload
    assert @item.sold?
  end

  # --- Checkout cancel action ---

  test "cancel does not change item status" do
    sign_in @user
    original_status = @item.status

    get checkout_cancel_url(item_id: @item.id)
    assert_response :success

    @item.reload
    assert_equal original_status, @item.status
  end
end
