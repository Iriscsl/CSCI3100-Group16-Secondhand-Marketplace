class CreateItems < ActiveRecord::Migration[8.1]
  def change
    create_table :items do |t|
      t.string :title
      t.text :description
      t.integer :price
      t.integer :status

      t.timestamps
    end
  end
end
