Feature: Item search and filters

  Scenario: User searches for an item
    Given there are items in the database
    When I visit the items page
    And I fill in "query" with "bike"
    And I press "Apply Filters"
    Then I should see "Bike"

  Scenario: User filters by community
    Given there are items in the database
    When I visit the items page
    And I select "Chung Chi College" from "community"
    And I press "Apply Filters"
    Then I should see "Bike"
    And I should not see "Laptop"