# 1. Setup the items and seller
Given("an item {string} exists") do |item_name|
  seller = User.create!(
    email: "1155212109@link.cuhk.edu.hk",
    name: "sellerr",
    password: "password",
    confirmed_at: Time.now # <--- FIXED: Devise requires this now
  )
  @item = Item.create!(title: item_name, price: 10, user: seller, status: 1, community: 0)
end

# 2. Buyer login
Given('I am logged in as a buyer') do
  @buyer = User.create!(
    email: "1155212108@link.cuhk.edu.hk",
    name: "buyerr",
    password: "password",
    confirmed_at: Time.now # <--- FIXED
  )
  login_as(@buyer, scope: :user)
end

# 3. Item page navigation
Given('I am on the page for item {string}') do |title|
  item = Item.find_by!(title: title)
  visit item_path(item)
end

# 4. Click specific link
When('I click the {string} button') do |button_text|
  click_on button_text # Usually "Message seller"
end

# 5. Verify conversation started from item
Then('I should see a conversation for {string}') do |text|
  expect(page).to have_content(text)
end

# 6. Seller login
Given("I am logged in as a seller") do
  @seller = User.create!(
    email: "1155000000@link.cuhk.edu.hk",
    password: "password",
    name: "sellller",
    confirmed_at: Time.now # <--- FIXED
  )
  login_as(@seller, scope: :user)
end

# 7. Setup seller items
Given("I have listed an item {string}") do |title|
  @item = Item.create!(title: title, price: 100, user: @seller, status: :available, community: :chung_chi)
end

# 8. Verify missing button
Then('I should not see the "Message Seller" button') do
  expect(page).not_to have_button('Message Seller')
  expect(page).not_to have_link('Message Seller')
end

# 9. Setup conversation
Given('I have started a conversation with the seller for {string}') do |item_title|
  item = Item.find_by!(title: item_title)
  seller = item.user

  @conversation = Conversation.create!(item: item, buyer: @buyer, seller: seller)
  visit conversation_path(@conversation)
end

# 10. Fill in message (Fixed to match exact view label and avoid regex ambiguity)
When('I fill in the message form with {string}') do |body|
  fill_in 'Message', with: body
end

# 11. Click send
# When('I click "Send"') do
#   click_button "Send"
# end

# 12. Verify message presence
Then('I should see {string} in the conversation thread') do |text|
  expect(page).to have_content(text)
end

# 13. Verify message count (Empty message scenario)
Given("there are {int} messages in this conversation") do |n|
  expect(@conversation.messages.count).to eq(n)
end

# 14. Attempt to send empty message
When('I click "Send" without entering a message') do
  click_button "Send"
end

# 15. Verify message count didn't change (Empty message scenario)
Then("the number of messages in this conversation should remain {int}") do |n|
  expect(@conversation.reload.messages.count).to eq(n)
end

# 16. Login generic user
Given('I am logged in as {string}') do |email|
  @user1 = User.find_by!(email: email)
  login_as(@user1, scope: :user) # <--- FIXED: Was logging in @user instead of @user1
end

# 17. View conversation list
When('I visit the conversation list page') do
  visit conversations_path
end

# 18. Verify conversation list ownership
Then("I should see only conversations that belong to me") do
  my_conversations = Conversation.where("buyer_id = :uid OR seller_id = :uid", uid: @user1.id)
  my_conversations.each do |conversation|
    expect(page).to have_content(conversation.item.title)
  end
end

# 19. Generic user account setup
Given('an user account with email {string} exists') do |email|
  User.find_or_create_by!(email: email) do |u|
    u.name = email.split("@").first
    u.password = "password"
    u.confirmed_at = Time.now # <--- FIXED
  end
end
