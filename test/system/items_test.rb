require "application_system_test_case"

class ItemsTest < ApplicationSystemTestCase
  test "visiting the items index" do
    visit items_url
    assert_text "Items"
  end
end
