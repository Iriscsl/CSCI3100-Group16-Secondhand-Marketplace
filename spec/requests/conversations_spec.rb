require "rails_helper"

RSpec.describe "Conversations", type: :request do
  let(:buyer)  { User.create!(email: "1155000100@link.cuhk.edu.hk", password: "password", name: "user1", confirmed_at: Time.now) }
  let(:seller) { User.create!(email: "1155000101@link.cuhk.edu.hk", password: "password", name: "user2", confirmed_at: Time.now) }
  let(:item) do
    Item.create!(
      title: "Item 1",
      price: 10,
      user: seller,
      status: 1,
      community: 0
    )
  end

  before do
    sign_in buyer  # Devise test helper
  end

  describe "GET /conversations" do
    it "lists only conversations where current_user is buyer or seller" do
      my_conversation = Conversation.create!(item: item, buyer: buyer, seller: seller)

      other_buyer  = User.create!(email: "1155000102@link.cuhk.edu.hk", password: "password", name: "user3", confirmed_at: Time.now)
      other_seller = User.create!(email: "1155000103@link.cuhk.edu.hk", password: "password", name: "user4", confirmed_at: Time.now)
      other_item   = Item.create!(title: "Item 2", price: 20, user: other_seller, status: 1, community: 0)
      Conversation.create!(item: other_item, buyer: other_buyer, seller: other_seller)

      get conversations_path

      expect(response).to have_http_status(:ok)
      expect(assigns(:conversations)).to contain_exactly(my_conversation)
    end
  end

  describe "GET /conversations/:id" do
    it "allows a participant to view the conversation" do
      conversation = Conversation.create!(item: item, buyer: buyer, seller: seller)

      get conversation_path(conversation)

      expect(response).to have_http_status(:ok)
      expect(assigns(:conversation)).to eq(conversation)
    end

    it "redirects a non-participant with an alert" do
      conversation = Conversation.create!(item: item, buyer: buyer, seller: seller)
      stranger = User.create!(email: "1155000104@link.cuhk.edu.hk", password: "password", name: "user5", confirmed_at: Time.now)

      sign_out buyer
      sign_in stranger

      get conversation_path(conversation)

      expect(response).to redirect_to(conversations_path)
      expect(flash[:alert]).to eq("You are not allowed to view this conversation.")
    end
  end

  describe "POST /conversations" do
    it "creates or finds a conversation and redirects to it" do
      expect {
        post conversations_path, params: {
          item_id:   item.id,
          seller_id: seller.id
        }
      }.to change(Conversation, :count).by(1)

      conversation = Conversation.last

      expect(conversation.item).to eq(item)
      expect(conversation.buyer).to eq(buyer)
      expect(conversation.seller).to eq(seller)
      expect(response).to redirect_to(conversation_path(conversation))
    end

    it "redirects back to items with errors if seller is not the item owner" do
      wrong_seller = User.create!(email: "1155000105@link.cuhk.edu.hk", password: "password", name: "user6", confirmed_at: Time.now)

      expect {
        post conversations_path, params: {
          item_id:   item.id,
          seller_id: wrong_seller.id
        }
      }.not_to change(Conversation, :count)

      expect(response).to redirect_to(items_path)
      expect(flash[:alert]).to include("must be the owner of the item")
    end
  end
end
