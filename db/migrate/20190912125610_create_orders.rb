class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name
      t.string :address
      t.date :send_date
      t.integer :send_timeframe
      t.integer :total_fee

      t.timestamps
    end
    add_reference :order_products, :order, foreign_key: true, index: true
  end
end
