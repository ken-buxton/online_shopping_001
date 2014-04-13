class CustomerShoppingListItem < ActiveRecord::Base
  belongs_to :customer_shopping_list, foreign_key: :customer_shopping_list_id
  belongs_to :product, foreign_key: :product_id
  
  def to_s; "shopping_list_name"; end           # So the state shows up in ActiveAdmin
end
