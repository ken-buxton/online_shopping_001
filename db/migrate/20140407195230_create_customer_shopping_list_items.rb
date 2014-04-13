class CreateCustomerShoppingListItems < ActiveRecord::Migration
  def change
    create_table :customer_shopping_list_items do |t|
      t.integer :customer_shopping_list_id
      t.integer :product_id
      t.decimal :quantity
      t.text :note

      t.timestamps
    end
  end
end
