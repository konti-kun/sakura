class CreateShoppingItems < ActiveRecord::Migration[5.2]
  def change
    create_table :shopping_items do |t|
      t.references :user, foreign_key: true
      t.references :product, foreign_key: true
      t.integer :number

      t.timestamps
    end
  end
end
