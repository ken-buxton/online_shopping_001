json.array!(@food_features) do |food_feature|
  json.extract! food_feature, :id, :name, :descr
  json.url food_feature_url(food_feature, format: :json)
end
