class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.string :image
      t.integer :price
      t.text :explanation
      t.boolean :is_displayed
      t.integer :sort_key

      t.timestamps
    end
  end
end
