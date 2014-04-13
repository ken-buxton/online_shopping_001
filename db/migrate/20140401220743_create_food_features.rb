class CreateFoodFeatures < ActiveRecord::Migration
  def change
    create_table :food_features do |t|
      t.string :name
      t.string :descr

      t.timestamps
    end
  end
end
