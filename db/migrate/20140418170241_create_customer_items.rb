class CreateCustomerItems < ActiveRecord::Migration
  def change
    create_table :customer_items do |t|
      t.integer :customer_id
      t.integer :product_id
      t.datetime :latest_reference_date

      t.timestamps
    end
  end
end
