require "test_helper"

class ItemsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)   # use the fixture user
    sign_in @user

    @item = items(:one)
  end

  test "should get index" do
    get items_url
    assert_response :success
  end

  test "should get new" do
    get new_item_url
    assert_response :success
  end

  test "should create item" do
    assert_difference("Item.count") do
      # post items_url, params: { item: { description: @item.description, price: @item.price, status: @item.status, title: @item.title } }
      post items_url, params: { item: { description: @item.description, price: @item.price, status: @item.status, title: @item.title, community: @item.community } }
    end

    assert_redirected_to item_url(Item.last)
  end

  test "should show item" do
    get item_url(@item)
    assert_response :success
  end

  test "should get edit" do
    get edit_item_url(@item)
    assert_response :success
  end

  test "should update item" do
    # patch item_url(@item), params: { item: { description: @item.description, price: @item.price, status: @item.status, title: @item.title } }
    patch item_url(@item), params: { item: { description: @item.description, price: @item.price, status: @item.status, title: @item.title, community: @item.community } }
    assert_redirected_to item_url(@item)
  end

  test "should destroy item" do
    assert_difference("Item.count", -1) do
      delete item_url(@item)
    end

    assert_redirected_to items_url
  end

  # --- update_status ---

  test "should update item status" do
    patch update_status_item_url(@item), params: { status: "reserved" }
    assert_redirected_to item_url(@item)

    @item.reload
    assert @item.reserved?
  end

  test "update_status redirects with notice on success" do
    patch update_status_item_url(@item), params: { status: "sold" }
    assert_redirected_to item_url(@item)
    follow_redirect!
    assert_match(/sold/, response.body, "Expected notice about status update")
  end

  # --- index filtering ---

  test "index filters by min_price" do
    get items_url, params: { min_price: 200 }
    assert_response :success
  end

  test "index filters by max_price" do
    get items_url, params: { max_price: 300 }
    assert_response :success
  end

  test "index filters by status" do
    get items_url, params: { status: ["available"] }
    assert_response :success
  end

  test "index filters by community" do
    get items_url, params: { community: "chung_chi" }
    assert_response :success
  end

  test "index with combined filters" do
    get items_url, params: { min_price: 50, max_price: 200, status: ["available"], community: "chung_chi" }
    assert_response :success
  end
end
