class State < ActiveRecord::Base  
  has_many :stores
  has_many :customers
  
  def to_s; state; end           # So the state shows up in ActiveAdmin
end
