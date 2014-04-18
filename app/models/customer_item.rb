class CustomerItem < ActiveRecord::Base
  belongs_to :customer, foreign_key: :customer_id
  belongs_to :product, foreign_key: :product_id
end
