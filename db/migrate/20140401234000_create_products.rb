class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :sku
      t.string :upc
      t.string :brand
      t.string :descr
      t.string :qty_desc
      t.decimal :min_qty_weight
      t.string :image
      t.string :category
      t.string :sub_category
      t.string :sub_category_group
      t.string :uofm
      t.decimal :price
      t.decimal :sale_price
      t.boolean :on_sale

      t.timestamps
    end
  end
end
