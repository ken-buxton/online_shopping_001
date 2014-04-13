ActiveAdmin.register Customer do
  permit_params :email, :password_digest, :account_no, :preferred_store_id, 
    :first_name, :last_name, :nick_name, :home_phone, :cell_phone, 
    :address1, :address2, :city, :state_id, :zip,
    tags_attributes: [:id, :store, :_destroy],
    tags_attributes: [:id, :state, :_destroy]
  
  config.per_page = 8

  index do
    column "Email", :email
    #column ":password_digest", :password_digest
    column "Account #", :account_no
    column "Preferred Store", :store
    column "First Name", :first_name
    column "Last Name", :last_name
    column "Nick Name", :nick_name
    column "Home Phone", :home_phone
    column "Cell Phone", :cell_phone
    column "Address1", :address1
    #column ":address2", :address2
    column "City", :city
    column "State", :state
    column "Zip", :zip
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
