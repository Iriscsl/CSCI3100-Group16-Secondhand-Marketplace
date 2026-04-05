require "rails_helper"

RSpec.describe Conversation, type: :model do
  describe "associations and dependent destroy" do
    it "links item/buyer/seller and destroys messages on delete" do
      owner  = User.create!(email: "1155000000@link.cuhk.edu.hk", password: "password")
      buyer  = User.create!(email: "1155000001@link.cuhk.edu.hk", password: "password")
      item   = Item.create!(title: "Item 1", price: 10, user: owner, status: 1, community: 0)

      conversation = Conversation.create!(item: item, buyer: buyer, seller: owner)
      msg1 = conversation.messages.create!(body: "hi",  sender: buyer)
      msg2 = conversation.messages.create!(body: "yo",  sender: owner)

      expect(conversation.item).to   eq(item)
      expect(conversation.buyer).to  eq(buyer)
      expect(conversation.seller).to eq(owner)
      expect(conversation.messages).to match_array([ msg1, msg2 ])

      expect { conversation.destroy }.to change(Message, :count).by(-2)
    end
  end

  describe "seller_must_match_item_owner validation" do
    let(:item_owner) { User.create!(email: "1155000002@link.cuhk.edu.hk", password: "password") }
    let(:other_user) { User.create!(email: "1155000003@link.cuhk.edu.hk", password: "password") }
    let(:buyer)      { User.create!(email: "1155000004@link.cuhk.edu.hk", password: "password") }
    let(:item) do
      Item.create!(
        title: "Item 1",
        price: 10,
        user: item_owner,
        status: 1,
        community: 0
      )
    end

    it "is valid when seller is the owner of the item" do
      conversation = Conversation.new(
        item:   item,
        buyer:  buyer,
        seller: item_owner
      )

      expect(conversation).to be_valid
    end

    it "is invalid when seller is not the owner of the item" do
      conversation = Conversation.new(
        item:   item,
        buyer:  buyer,
        seller: other_user
      )

      expect(conversation).not_to be_valid
      expect(conversation.errors[:seller]).to include("must be the owner of the item")
    end

    it "does not add a custom error if item is missing" do
      conversation = Conversation.new(
        buyer:  buyer,
        seller: item_owner
      )

      conversation.valid?

      # no custom validation error (only potential belongs_to :item error)
      expect(conversation.errors[:seller]).not_to include("must be the owner of the item")
    end
  end
end
