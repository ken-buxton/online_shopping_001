json.array!(@stores) do |store|
  json.extract! store, :id, :name, :address1, :address2, :city, :state_id, :zip
  json.url store_url(store, format: :json)
end
