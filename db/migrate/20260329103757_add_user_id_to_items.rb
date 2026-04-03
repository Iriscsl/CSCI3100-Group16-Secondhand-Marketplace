class AddUserIdToItems < ActiveRecord::Migration[8.1]
  def change
    # add_reference :items, :user, null: false, foreign_key: true
    add_reference :items, :user, foreign_key: true
  end
end
