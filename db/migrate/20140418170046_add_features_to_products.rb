class AddFeaturesToProducts < ActiveRecord::Migration
  def change
    add_column :products, :featured_item, :boolean
    add_column :products, :food_feature, :string
  end
end
