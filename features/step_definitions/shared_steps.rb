Given("a confirmed user exists with email {string} and password {string}") do |email, password|
  @user = User.create!(
    name: "Test User",
    email: email,
    password: password,
    password_confirmation: password,
    confirmed_at: Time.current
  )
end

Given("an item exists with title {string} and price {int}") do |title, price|
  @item = Item.create!(
    title: title,
    description: "Test description",
    price: price,
    status: :available,
    community: :new_asia,
    user: @user
  )
end

Given("I am signed in as {string} with password {string}") do |email, password|
  visit new_user_session_path
  fill_in "Email", with: email
  fill_in "Password", with: password
  click_button "Log in"
end

Then("I should be redirected to the sign-in page") do
  expect(current_path).to eq(new_user_session_path)
end
