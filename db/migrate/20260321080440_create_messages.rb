class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.integer :conversation_id
      t.integer :sender_id
      t.text :body

      t.timestamps
    end
  end
end
