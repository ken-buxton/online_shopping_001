json.array!(@products) do |product|
  json.extract! product, :id, :sku, :upc, :brand, :descr, :qty_desc, :min_qty_weight, :image, :category, :sub_category, :sub_category_group, :uofm, :price, :sale_price, :on_sale
  json.url product_url(product, format: :json)
end
