json.array!(@customers) do |customer|
  json.extract! customer, :id, :email, :password_digest
  json.url customer_url(customer, format: :json)
end
