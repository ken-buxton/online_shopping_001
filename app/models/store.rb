class Store < ActiveRecord::Base
  belongs_to :state
  has_many :customers
  
  def to_s; name; end           # So the state shows up in ActiveAdmin
end
