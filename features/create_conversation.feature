Feature: create conversation 
  As a buyer 
  So that I can discuss the details with the seller of item 
  I want to create a conversation with the seller about the item 

Scenario:  Buyer starts a conversation from an item page
  Given an item "item1" exists  
  And I am logged in as a buyer 
  And I am on the page for item "item1" 
  When I click the "Message seller" button
  Then I should see a conversation for "item1" 

Scenario: 
  Given I am logged in as a seller 
  And I have listed an item "my item" 
  And I am on the page for item "my item" 
  Then I should not see the "Message seller" button