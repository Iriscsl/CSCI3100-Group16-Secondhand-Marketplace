require "rails_helper"

RSpec.describe Item, type: :model do
  describe "scopes" do
    let!(:user) do
      User.create!(
        name: "Test User",
        email: "1155123456@link.cuhk.edu.hk",
        password: "password123",
        confirmed_at: Time.current
      )
    end

    let!(:item1) do
      Item.create!(
        title: "Bike",
        description: "Good bicycle",
        price: 100,
        status: "available",
        community: "chung_chi",
        user: user
      )
    end

    let!(:item2) do
      Item.create!(
        title: "Laptop",
        description: "Gaming laptop",
        price: 2000,
        status: "sold",
        community: "shaw",
        user: user
      )
    end

    it "filters by status" do
      result = Item.with_statuses([ "available" ])
      expect(result).to include(item1)
      expect(result).not_to include(item2)
    end

    it "filters by min price" do
      result = Item.min_price(500)
      expect(result).to include(item2)
      expect(result).not_to include(item1)
    end

    it "filters by max price" do
      result = Item.max_price(500)
      expect(result).to include(item1)
      expect(result).not_to include(item2)
    end

    it "filters by community" do
      result = Item.with_community("chung_chi")
      expect(result).to include(item1)
      expect(result).not_to include(item2)
    end

    it "searches items by title or description" do
      result = Item.search_items("bicycl")
      expect(result).to include(item1)
    end
  end
end
