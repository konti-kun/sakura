class RenameShoppingItemToOrderProduct < ActiveRecord::Migration[5.2]
  def up
    remove_index :shopping_items, [:user_id, :product_id]
    rename_table :shopping_items, :order_products
    add_index :order_products, [:order_id, :product_id], unique: true
  end
  def down
    remove_index :order_products, name: 'index_order_products_on_order_id_and_product_id'
    rename_table :shopping_items, :order_products
    add_index :shopping_items, [:user_id, :product_id], unique: true
  end
end
