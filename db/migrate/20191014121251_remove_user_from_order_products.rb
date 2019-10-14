class RemoveUserFromOrderProducts < ActiveRecord::Migration[5.2]
  def change
    remove_reference :order_products, :user, foreign_key: true
  end
end
