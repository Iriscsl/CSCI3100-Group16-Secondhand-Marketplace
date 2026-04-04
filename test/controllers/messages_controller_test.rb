require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @conversation = conversations(:one)
    @participant  = users(:two)
    @other_user   = users(:three)
  end

  test "should require login to create message" do
    assert_no_difference("Message.count") do
      post conversation_messages_url(@conversation),
           params: { message: { body: "Hi" } }
    end
    assert_redirected_to new_user_session_path
  end

  test "participant can create message in conversation" do
    sign_in @participant

    assert_difference("Message.count", 1) do
      post conversation_messages_url(@conversation),
           params: { message: { body: "Hello there" } }
    end

    assert_redirected_to conversation_url(@conversation)
    assert_equal @participant, Message.last.sender
    assert_equal @conversation, Message.last.conversation
  end

  test "non participant cannot create message" do
    sign_in @other_user

    assert_no_difference("Message.count") do
      post conversation_messages_url(@conversation),
           params: { message: { body: "I should not be here" } }
    end

    assert_redirected_to conversations_url
    assert_equal "You are not allowed to access this conversation.", flash[:alert]
  end

  test "does not create blank message" do
    sign_in @participant

    assert_no_difference("Message.count") do
      post conversation_messages_url(@conversation),
           params: { message: { body: "" } }
    end

    assert_response :unprocessable_entity
  end
end
