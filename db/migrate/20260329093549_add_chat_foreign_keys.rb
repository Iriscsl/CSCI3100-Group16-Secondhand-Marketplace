class AddChatForeignKeys < ActiveRecord::Migration[8.1]
  def change
    # Indexes for performance
    add_index :conversations, :item_id
    add_index :conversations, :buyer_id
    add_index :conversations, :seller_id
    add_index :messages, :conversation_id
    add_index :messages, :sender_id

    # Foreign key constraints
    add_foreign_key :conversations, :items, column: :item_id
    add_foreign_key :conversations, :users, column: :buyer_id
    add_foreign_key :conversations, :users, column: :seller_id
    add_foreign_key :messages,      :conversations, column: :conversation_id
    add_foreign_key :messages,      :users, column: :sender_id
  end
end
