ActiveAdmin.register CustomerShoppingListItem do
  permit_params :customer_shopping_list_id, :product_id, :quantity, :note,
    tags_attributes: [:id, :customer_shopping_list, :_destroy],
    tags_attributes: [:id, :product, :_destroy]
  
  config.per_page = 8

  index do
    column "Shopping List Name", :customer_shopping_list
    column "Product", :product
    column "Quantity", :quantity
    column "Note", :note
    default_actions
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
