# Checkout steps
When("I post to checkout for that item") do
  page.driver.post checkout_path, item_id: @item.id
  while page.driver.response.status.between?(300, 399)
    page.driver.get page.driver.response.location
  end
end

When("I visit the checkout success page for that item") do
  visit checkout_success_path(item_id: @item.id)
end

When("I visit the checkout cancel page for that item") do
  visit checkout_cancel_path(item_id: @item.id)
end

Then("the item status should be {string}") do |status|
  @item.reload
  expect(@item.status).to eq(status)
end

# Digest steps
Given("a recent item exists with title {string} and price {int}") do |title, price|
  Item.create!(
    title: title,
    description: "Recent test item",
    price: price,
    status: :available,
    community: :shaw,
    user: @user,
    created_at: 2.hours.ago
  )
end

Given("an old item exists with title {string} and price {int}") do |title, price|
  Item.create!(
    title: title,
    description: "Old test item",
    price: price,
    status: :available,
    community: :united,
    user: @user,
    created_at: 3.days.ago
  )
end

When("I visit the digest page") do
  visit daily_digest_path
end
