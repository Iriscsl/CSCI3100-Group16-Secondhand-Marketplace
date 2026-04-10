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
