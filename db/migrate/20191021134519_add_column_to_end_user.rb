class AddColumnToEndUser < ActiveRecord::Migration[5.2]
  def change
    add_column :end_users, :nickname, :string
    add_column :end_users, :image, :string
  end
end
