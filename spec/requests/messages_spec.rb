require "rails_helper"

RSpec.describe "Messages", type: :request do
  let(:buyer)  { User.create!(email: "1155000200@link.cuhk.edu.hk", password: "password", name: "user1", confirmed_at: Time.now) }
  let(:seller) { User.create!(email: "1155000201@link.cuhk.edu.hk", password: "password", name: "user2", confirmed_at: Time.now) }
  let(:item) do
    Item.create!(
      title: "Item 1",
      price: 10,
      user: seller,
      status: 1,
      community: 0
    )
  end
  let(:conversation) { Conversation.create!(item: item, buyer: buyer, seller: seller) }

  before do
    sign_in buyer
  end

  describe "POST /conversations/:conversation_id/messages" do
    context "as a participant" do
      it "creates a message with valid params and redirects (HTML)" do
        expect {
          post conversation_messages_path(conversation), params: {
            message: { body: "Hello seller" }
          }
        }.to change(Message, :count).by(1)

        message = Message.last
        expect(message.conversation).to eq(conversation)
        expect(message.sender).to eq(buyer)
        expect(response).to redirect_to(conversation_path(conversation))
        expect(flash[:notice]).to eq("Message sent.")
      end

      it "does not create a message with empty body and re-renders show" do
        expect {
          post conversation_messages_path(conversation), params: {
            message: { body: "" }
          }
        }.not_to change(Message, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template("conversations/show")
      end
    end

    context "as a non-participant" do
      it "redirects to conversations index and does not create a message" do
        stranger = User.create!(email: "1155000202@link.cuhk.edu.hk", password: "password", name: "user3", confirmed_at: Time.now)
        sign_out buyer
        sign_in stranger

        expect {
          post conversation_messages_path(conversation), params: {
            message: { body: "Hacking" }
          }
        }.not_to change(Message, :count)

        expect(response).to redirect_to(conversations_path)
        expect(flash[:alert]).to eq("You are not allowed to access this conversation.")
      end
    end
  end
end
