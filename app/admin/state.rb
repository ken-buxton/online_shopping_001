ActiveAdmin.register State do
  permit_params :state, :state2
  
  index do
    column "State", :state
    column "State - 2 char", :state2
    default_actions
  end

  show  :title => :state do |state|
    attributes_table do
      row :id
      row :state
      row :state2
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
