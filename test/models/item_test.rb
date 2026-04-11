require "test_helper"

class ItemTest < ActiveSupport::TestCase
  setup do
    @available_item = items(:one)   # price: 100, status: available (0), community: chung_chi (0)
    @reserved_item  = items(:two)   # price: 250, status: reserved (1),  community: new_asia (2)
    @sold_item      = items(:three) # price: 500, status: sold (2),      community: morningside (4)
  end

  # --- Status enum ---

  test "status enum values are correct" do
    assert @available_item.available?
    assert @reserved_item.reserved?
    assert @sold_item.sold?
  end

  # --- Community enum ---

  test "community enum values are correct" do
    assert @available_item.chung_chi?
    assert @reserved_item.chung_chi?
    assert @sold_item.morningside?
  end

  # --- community_name ---

  test "community_name returns full college name" do
    assert_equal "Chung Chi College", @available_item.community_name
    assert_equal "Chung Chi College", @reserved_item.community_name
    assert_equal "Morningside College", @sold_item.community_name
  end

  test "community_name returns 'Not specified' when nil" do
    item = Item.new(community: nil)
    assert_equal "Not specified", item.community_name
  end

  # --- with_statuses scope ---

  test "with_statuses returns all when blank" do
    assert_equal Item.all.count, Item.with_statuses(nil).count
    assert_equal Item.all.count, Item.with_statuses([]).count
  end

  test "with_statuses filters by single status" do
    results = Item.with_statuses([ "available" ])
    assert results.all?(&:available?)
  end

  test "with_statuses filters by multiple statuses" do
    results = Item.with_statuses([ "available", "reserved" ])
    results.each do |item|
      assert item.available? || item.reserved?
    end
  end

  # --- min_price scope ---

  test "min_price returns all when blank" do
    assert_equal Item.all.count, Item.min_price(nil).count
  end

  test "min_price filters items below threshold" do
    results = Item.min_price(200)
    results.each { |item| assert item.price >= 200 }
  end

  # --- max_price scope ---

  test "max_price returns all when blank" do
    assert_equal Item.all.count, Item.max_price(nil).count
  end

  test "max_price filters items above threshold" do
    results = Item.max_price(300)
    results.each { |item| assert item.price <= 300 }
  end

  # --- combined price scopes ---

  test "min_price and max_price combined narrows results" do
    results = Item.min_price(150).max_price(400)
    assert_not_empty results, "Expected at least one item in the 150-400 range"
    results.each do |item|
      assert item.price >= 150
      assert item.price <= 400
    end
  end

  # --- with_community scope ---

  test "with_community returns all when blank" do
    assert_equal Item.all.count, Item.with_community(nil).count
  end

  test "with_community filters by community" do
    results = Item.with_community("chung_chi")
    results.each { |item| assert item.chung_chi? }
  end

  # --- belongs_to user ---

  test "item belongs to a user" do
    assert_not_nil @available_item.user
    assert_equal users(:one), @available_item.user
  end
end
