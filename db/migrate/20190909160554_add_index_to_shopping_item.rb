class AddIndexToShoppingItem < ActiveRecord::Migration[5.2]
  def change
    add_index :shopping_items, [:user, :product], unique: true
  end
end
