Feature: Manage Items
  As a logged-in CUHK student
  I want to create, view, edit, and change the status of my items
  So that I can sell my second-hand goods

  Background:
    Given I am logged in as a CUHK user

  Scenario: Create a new item
    When I go to the new item page
    And I fill in "Title" with "Calculus Textbook"
    And I fill in "Description" with "Like new, no markings"
    And I fill in "Price" with "50"
    And I select "Available" from "Status"
    And I select "Chung Chi College" from "Community"
    And I click "Create Item"
    Then I should see "Item was successfully created"
    And I should see "Calculus Textbook"

  Scenario: View all items
    Given there is an item titled "Bicycle" posted by another user
    When I go to the items list page
    Then I should see "Bicycle"

  Scenario: View a single item
    Given I have an item titled "Guitar"
    When I go to that item's page
    Then I should see "Guitar"
    And I should see the price

  Scenario: Edit an item
    Given I have an item titled "Old Title"
    When I go to edit that item
    And I change the title to "New Title"
    And I click "Update Item"
    Then I should see "Item was successfully updated"
    And I should see "New Title"

  Scenario: Delete an item
    Given I have an item titled "Unwanted Item"
    When I go to that item's page
    And I click "Delete"
    Then I should see "Item was successfully destroyed"
    And I should not see "Unwanted Item"

  Scenario: Mark an item as reserved
    Given I have an available item titled "Phone"
    When I go to that item's page
    And I click "Mark as Reserved"
    Then I should see "Status updated to reserved"
    And the item status should become "reserved"

  Scenario: Mark an item as sold
    Given I have a reserved item titled "Laptop"
    When I go to that item's page
    And I click "Mark as Sold"
    Then I should see "Status updated to sold"
    And the item status should become "sold"