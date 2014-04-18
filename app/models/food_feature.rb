class FoodFeature < ActiveRecord::Base
  def to_s; name; end           # So the customer email shows up in ActiveAdmin
end
