class RenameShoppingItemToOrderProduct < ActiveRecord::Migration[5.2]
  def change
    rename_table :shopping_items, :order_products
  end
end
