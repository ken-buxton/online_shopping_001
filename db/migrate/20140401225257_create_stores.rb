class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.string :address1
      t.string :address2
      t.string :city
      t.integer :state_id
      t.string :zip

      t.timestamps
    end
  end
end
