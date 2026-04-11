Feature: Chat message 
  As a conversation participant 
  So that I can communicate with buyer or seller 
  I want to be able to send message 

Scenario: Buyer sends a first message in a conversation 
  Given an item "item1" exists 
  And I am logged in as a buyer 
  And I am on the page for item "item1" 
  And I have started a conversation with the seller for "item1"
  When I fill in "Message" with "Hi, is this still available?" 
  And I click "Send" 
  Then I should see "Hi, is this still available?" in the conversation thread

Scenario: User cannot send an empty message 
  Given an item "item1" exists 
  And I am logged in as a buyer 
  And I have started a conversation with the seller for "item1"  
  And there are 0 messages in this conversation
  When I click "Send" without entering a message 
  Then the number of messages in this conversation should remain 0
