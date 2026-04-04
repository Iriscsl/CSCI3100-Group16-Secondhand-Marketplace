require "test_helper"

class ConversationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @buyer        = users(:one)
    @seller       = users(:two)
    @item         = items(:one)
    @conversation = conversations(:one)
  end

  test "should get index when signed in" do
    sign_in @buyer
    get conversations_url
    assert_response :success
  end

  test "should redirect index when not signed in" do
    get conversations_url
    assert_redirected_to new_user_session_path
  end

  test "should show conversation for participant" do
    sign_in @buyer           
    get conversation_url(@conversation)
    assert_response :success
  end

  test "should redirect show for non participant" do
    sign_in users(:three)
    get conversation_url(@conversation)
    assert_redirected_to conversations_url
    assert_equal "You are not allowed to view this conversation.", flash[:alert]
  end

  test "should not create duplicate conversation" do
    sign_in users(:two) 

    item = items(:one) 
    seller = item.user 

    assert_no_difference("Conversation.count") do
      post conversations_url, params: {
        item_id:   item.id,
        seller_id: seller.id      
      }
    end

    assert_redirected_to conversation_url(conversations(:one))
  end

  test "should create new conversation" do 
    sign_in users(:three) 

    item = items(:one) 
    seller = item.user 

    assert_difference("Conversation.count", 1) do 
      post conversations_url, params: {
        item_id: item.id, 
        seller_id: seller.id 
      }
    end
  end 

  test "should not create conversation when seller is not item owner" do
    sign_in users(:two)

    item = items(:one)
    wrong_seller = users(:three)

    assert_no_difference("Conversation.count") do
      post conversations_url, params: {
        item_id: item.id,
        seller_id: wrong_seller.id
      }
    end 

    assert_redirected_to items_url 
    assert_match "must be the owner of the item", flash[:alert]
  end 

  test "index shows only conversations for current user" do 
    sign_in users(:two) 
    get conversations_url 

    assert_response :success 
    assigns_conversations = assigns(:conversations) 
    assert assigns_conversations.all? { |c| c.buyer == users(:two) || c.seller == users(:two) } 
  end
end
