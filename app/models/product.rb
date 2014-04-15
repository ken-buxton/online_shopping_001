class Product < ActiveRecord::Base
  has_many :customer_shopping_list_items, dependent: :destroy
  
  def to_s; 
    if brand.size > 0
      "#{brand}-#{descr}"
    else
      "#{descr}"
    end
  end           # So the state shows up in ActiveAdmin
end
