require "rails_helper"

RSpec.describe Message, type: :model do
  describe "associations" do
    it "belongs to a conversation and a sender" do
      owner  = User.create!(email: "1155000010@link.cuhk.edu.hk", password: "password")
      buyer  = User.create!(email: "1155000011@link.cuhk.edu.hk", password: "password")
      item   = Item.create!(title: "Item 1", price: 10, user: owner, status: 1, community: 0)
      convo  = Conversation.create!(item: item, buyer: buyer, seller: owner)

      message = Message.create!(conversation: convo, sender: buyer, body: "hello")

      expect(message.conversation).to eq(convo)
      expect(message.sender).to       eq(buyer)
    end
  end

  describe "validations" do
    it "is invalid without a body" do
      owner  = User.create!(email: "1155000012@link.cuhk.edu.hk", password: "password")
      buyer  = User.create!(email: "1155000013@link.cuhk.edu.hk", password: "password")
      item   = Item.create!(title: "Item 2", price: 20, user: owner, status: 1, community: 0)
      convo  = Conversation.create!(item: item, buyer: buyer, seller: owner)

      message = Message.new(conversation: convo, sender: buyer, body: "")

      expect(message).not_to be_valid
      expect(message.errors[:body]).to include("can't be blank")
    end

    it "is valid with a body" do
      owner  = User.create!(email: "1155000014@link.cuhk.edu.hk", password: "password")
      buyer  = User.create!(email: "1155000015@link.cuhk.edu.hk", password: "password")
      item   = Item.create!(title: "Item 3", price: 30, user: owner, status: 1, community: 0)
      convo  = Conversation.create!(item: item, buyer: buyer, seller: owner)

      message = Message.new(conversation: convo, sender: buyer, body: "Nice item!")

      expect(message).to be_valid
    end
  end

  describe "callbacks" do
    it "calls broadcast_message after create" do
      owner  = User.create!(email: "1155000016@link.cuhk.edu.hk", password: "password")
      buyer  = User.create!(email: "1155000017@link.cuhk.edu.hk", password: "password")
      item   = Item.create!(title: "Item 4", price: 40, user: owner, status: 1, community: 0)
      convo  = Conversation.create!(item: item, buyer: buyer, seller: owner)

      # We just want to ensure the callback runs, not to test Turbo itself.
      expect_any_instance_of(Message).to receive(:broadcast_message)

      Message.create!(conversation: convo, sender: buyer, body: "Ping")
    end
  end
end
