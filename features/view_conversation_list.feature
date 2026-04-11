Feature: View conversation list
  As a logged-in user
  I want to see only my own conversations
  So that I do not access other users' messages

Scenario: 
  Given an user account with email "1155212109@link.cuhk.edu.hk" exists 
  Given I am logged in as "1155212109@link.cuhk.edu.hk" 
  When I visit the conversation list page 
  Then I should see only conversations that belong to me
