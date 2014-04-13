ActiveAdmin.register Store do
  permit_params :name, :address1, :address2, :city, :state_id, :zip, 
    tags_attributes: [:id, :state]
    #tags_attributes: [:id, :state, :_destroy]

  index do
    column "Store Name", :name
    column "Address 1", :address1
    column "Address 2", :address2
    column "City", :city
    column "State", :state
    column "Zip", :zip
    default_actions
  end

  show  :title => :state do |state|
    attributes_table do
      row :id
      row :name
      row :address1
      row :address2
      row :city
      row :state
      row :zip
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
