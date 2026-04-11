Feature: Daily Digest
  As a registered user
  I want to see a daily digest of new items
  So that I can stay up to date with new listings

  Background:
    Given a confirmed user exists with email "1155066666@link.cuhk.edu.hk" and password "password123"

  Scenario: Unauthenticated user cannot view digest
    When I visit the digest page
    Then I should be redirected to the sign-in page

  Scenario: Viewing digest shows recent items
    Given I am signed in as "1155066666@link.cuhk.edu.hk" with password "password123"
    And a recent item exists with title "New Laptop" and price 3000
    When I visit the digest page
    Then I should see "New Laptop"

  Scenario: Digest does not show old items
    Given I am signed in as "1155066666@link.cuhk.edu.hk" with password "password123"
    And an old item exists with title "Ancient Phone" and price 100
    When I visit the digest page
    Then I should not see "Ancient Phone"
