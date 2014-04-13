class CreateCustomerShoppingLists < ActiveRecord::Migration
  def change
    create_table :customer_shopping_lists do |t|
      t.integer :customer_id
      t.string :shopping_list_name

      t.timestamps
    end
  end
end
