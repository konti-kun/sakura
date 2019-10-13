class CreateEndUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :end_users do |t|
      t.belongs_to :user
      t.string :name
      t.string :address

      t.timestamps
    end
  end
end
