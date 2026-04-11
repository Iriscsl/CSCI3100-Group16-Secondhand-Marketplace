Feature: Stripe Checkout
  As a logged-in buyer
  I want to purchase an item via Stripe
  So that I can pay securely

  Background:
    Given a confirmed user exists with email "1155077777@link.cuhk.edu.hk" and password "password123"
    And an item exists with title "CSCI3100 Textbook" and price 150

  Scenario: Unauthenticated user cannot checkout
    When I post to checkout for that item
    Then I should be redirected to the sign-in page

  Scenario: Successful checkout marks item as sold
    Given I am signed in as "1155077777@link.cuhk.edu.hk" with password "password123"
    When I visit the checkout success page for that item
    Then the item status should be "sold"

  Scenario: Cancelled checkout keeps item available
    Given I am signed in as "1155077777@link.cuhk.edu.hk" with password "password123"
    When I visit the checkout cancel page for that item
    Then the item status should be "available"
