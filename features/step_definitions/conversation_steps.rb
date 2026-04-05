Given("an item {string} exists") do |item_name|
  seller = User.create!(email: "1155212109@link.cuhk.edu.hk", name: "sellerr", password: "password")
  @item = Item.create!(title: item_name, price: 10, user: seller, status: 1, community: 0)
end

Given('I am logged in as a buyer') do
  @buyer = User.create!(email: "1155212108@link.cuhk.edu.hk", name: "buyerr", password: "password")
  login_as(@buyer, scope: :user)
end

Given('I am on the page for item {string}') do |string|
  item = Item.find_by!(title: string)
  visit item_path(@item)
end

When('I click the {string} button') do |string|
  click_on "Message seller"
end

Then('I should see a conversation for {string}') do |string|
  expect(page).to have_content(string)
end

Given("I am logged in as a seller") do
  @seller = User.create!(email: "1155000000@link.cuhk.edu.hk", password: "password", name: "sellller")
  login_as(@seller, scope: :user)
end

Given("I have listed an item {string}") do |title|
  @item = Item.create!(title: title, price: 100, user: @seller)
end

Then('I should not see the "Message seller" button') do
  expect(page).not_to have_button('Message seller')
  expect(page).not_to have_link('Message seller')
end

Given('I have started a conversation with the seller for {string}') do |item_title|
  item = Item.find_by!(title: item_title)
  seller = item.user

  @conversation = Conversation.create!(item: item, buyer: @buyer, seller: seller)
  visit conversation_path(@conversation)
end

When /I fill in "Message" with (.*)/ do |body|
  fill_in "message_body", with: body
end

When('I click "Send"') do
  click_button "Send"
end

Then('I should see {string} in the conversation thread') do |text|
  expect(page).to have_content(text)
end

Given("there are {int} messages in this conversation") do |n|
  expect(@conversation.messages.count).to eq(n)
end

When('I click "Send" without entering a message') do
  click_button "Send"
end

Then("the number of messages in this conversation should remain {int}") do |n|
  expect(@conversation.messages.count).to eq(n)
end

Given('I am logged in as {string}') do |email|
  @user1 = User.find_by!(email: email)
  login_as(@user, scope: :user)
end

When('I visit the conversation list page') do
  visit conversations_path
end

Then("I should see only conversations that belong to me") do
  my_conversations = Conversation.where("buyer_id = :uid OR seller_id = :uid", uid: @user1.id)
end

Given('an user account with email {string} exists') do |email|
  User.find_or_create_by!(email: email) do |u|
    u.name = email.split("@").first
    u.password = "password"
  end
end
