class CustomerShoppingList < ActiveRecord::Base
  belongs_to :customer, foreign_key: :customer_id
  has_many :customer_shopping_list_items, dependent: :destroy
  
  def to_s; shopping_list_name; end           # So the name of the shopping list shows up in ActiveAdmin
end
