class CreateConversations < ActiveRecord::Migration[8.1]
  def change
    create_table :conversations do |t|
      t.integer :item_id
      t.integer :buyer_id
      t.integer :seller_id

      t.timestamps
    end
  end
end
