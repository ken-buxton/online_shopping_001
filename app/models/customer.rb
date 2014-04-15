class Customer < ActiveRecord::Base
  belongs_to :state
  belongs_to :store, foreign_key: :preferred_store_id
  has_many :customer_shopping_lists, dependent: :destroy
  
  def to_s; email; end           # So the customer email shows up in ActiveAdmin
end
