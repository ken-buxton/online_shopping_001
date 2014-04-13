ActiveAdmin.register Product do
  permit_params :sku, :upc, :brand, :descr, :qty_desc, :min_qty_weight, :image, 
    :category, :sub_category, :sub_category_group, :uofm, :price, :sale_price, :on_sale
  
  config.per_page = 8

  index do
    column "SKU", :sku
    #column "UPC", :upc
    column "Brand", :brand
    column "Description", :descr
    column "Qty Descr", :qty_desc
    column "Min Qty Weight", :min_qty_weight
    column "Image", :image
    column "Category", :category
    column "Sub-category", :sub_category
    column "SC Group", :sub_category_group
    column "UofM", :uofm
    column "Price", :price
    column "Sale Price", :sale_price
    column "On Sale?", :on_sale

    default_actions
  end

  show  :title => :sku do |product|
    attributes_table do
      row :sku
      row :upc
      row :brand
      row :descr
      row :qty_desc
      row :min_qty_weight
      row :image
      row :category
      row :sub_category
      row :sub_category_group
      row :uofm
      row :price
      row :sale_price
      row :on_sale
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end
  
end
