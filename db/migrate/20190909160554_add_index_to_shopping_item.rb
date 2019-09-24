class AddIndexToShoppingItem < ActiveRecord::Migration[5.2]
  def change
    add_index :shopping_items, [:user_id, :product_id], unique: true
  end
end
