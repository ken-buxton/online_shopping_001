class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :email
      t.string :password_digest
      t.string :account_no
      t.integer :preferred_store_id
      t.string :first_name
      t.string :last_name
      t.string :nick_name
      t.string :home_phone
      t.string :cell_phone
      t.string :address1
      t.string :address2
      t.string :city
      t.integer :state_id
      t.string :zip

      t.timestamps
    end
  end
end
