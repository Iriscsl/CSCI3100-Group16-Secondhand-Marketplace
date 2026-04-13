Given("there are items in the database") do
  user = User.create!(
    name: "username1",
    email: "1155123456@link.cuhk.edu.hk",
    password: "password123"
  )

  Item.create!(
    title: "Bike",
    description: "Good bicycle",
    price: 100,
    status: "available",
    community: "chung_chi",
    user: user
  )

  Item.create!(
    title: "Laptop",
    description: "Gaming laptop",
    price: 2000,
    status: "sold",
    community: "shaw",
    user: user
  )
end

When("I visit the items page") do
  visit items_path
end

When("I fill in {string} with {string}") do |field, value|
  fill_in field, with: value
end

When("I press {string}") do |button|
  click_button button
end

When("I select {string} from {string}") do |value, field|
  select value, from: field
end

Then("I should see {string}") do |text|
  expect(page).to have_content(text)
end

Then("I should not see {string}") do |text|
  expect(page).not_to have_content(text)
end



# login
Given("I am logged in as a CUHK user") do
  @user = User.create!(
    email: "1155123456@link.cuhk.edu.hk",
    password: "password123",
    name: "Test User",
    confirmed_at: Time.now
  )
  login_as(@user, scope: :user)
end

# Navigation steps
When("I go to the new item page") do
  visit new_item_path
end

When("I go to the items list page") do
  visit items_path
end

# Setup
Given("there is an item titled {string} posted by another user") do |title|
  other_user = User.create!(
    email: "1155777777@link.cuhk.edu.hk",
    password: "password123",
    name: "Other User",
    confirmed_at: Time.now
  )
  Item.create!(
    title: title,
    description: "Test",
    price: 10,
    status: :available,
    community: 0,
    user: other_user
  )
end

Given("I have an item titled {string}") do |title|
  @item = Item.create!(
    title: title,
    description: "Test",
    price: 10,
    status: :available,
    community: 0,
    user: @user
  )
end

Given("I have an available item titled {string}") do |title|
  @item = Item.create!(
    title: title,
    description: "Test",
    price: 10,
    status: :available,
    community: 0,
    user: @user
  )
end

Given("I have a reserved item titled {string}") do |title|
  @item = Item.create!(
    title: title,
    description: "Test",
    price: 10,
    status: :reserved,
    community: 0,
    user: @user
  )
end

When("I go to that item's page") do
  visit item_path(@item)
end

When("I go to edit that item") do
  visit edit_item_path(@item)
end

When("I change the title to {string}") do |new_title|
  fill_in "Title", with: new_title
end

Then("the item status should become {string}") do |new_status|
  @item.reload
  expect(@item.status).to eq(new_status)
end

When("I click {string}") do |button|
  click_button button
end

Then("I should see the price") do
  expect(page).to have_text(/\$\d+/)
end
