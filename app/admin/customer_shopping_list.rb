ActiveAdmin.register CustomerShoppingList do
  permit_params :customer_id, :shopping_list_name,
    tags_attributes: [:id, :customer, :_destroy]
  
  config.per_page = 8

  index do
    column "Customer", :customer
    column "Shopping List Name", :shopping_list_name
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
