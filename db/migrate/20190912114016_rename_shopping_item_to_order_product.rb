class RenameShoppingItemToOrderProduct < ActiveRecord::Migration[5.2]
  def up
    remove_index :shopping_items, [:user_id, :product_id]
    rename_table :shopping_items, :order_products
  end
  def down
    rename_table :shopping_items, :order_products
    add_index :shopping_items, [:user_id, :product_id], unique: true
  end
end
