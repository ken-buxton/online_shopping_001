class StoreController < ApplicationController
  
  def index
    # Parameter variables: :set_customer_email, :set_customer_shopping_list, :add_to_list, :delete_from_list, :commit, :shopping_list_name,
    #   :category, :sub_category, :sub_category_group
    #   :set_change_qty_x (where x is a multi-digit number)
    # 
    # Session variables: :category, :sub_category, :sub_category_group, :customer_shopping_list_name, :customer_email
    # 
    # Make sure all session variables have a value (nil if don't exist)
    session_vars = [:category, :sub_category, :sub_category_group, :customer_shopping_list_name, :customer_email]
    session_vars.each do |session_var|
      if session[session_var].nil?
        session[session_var] = ""
      end
    end
    
    # ************************************************************
    # Handle changes to the current customer or 
    # current customer's shopping list.
    # ************************************************************
    if not params[:set_customer_email].nil?
      # Changed current customer
      # Set to new customer and reset previous category, sub_category, and sub_category_group
      session[:category] = ""
      session[:sub_category] = ""
      session[:sub_category_group] = ""
      session[:customer_shopping_list_name] = ""
      if params[:set_customer_email].blank?
        session[:customer_email] = ""
      else
        session[:customer_email] = params[:set_customer_email]
        # Handle case where we just switched customers and they have a single shopping list
        customer_id, customer_shopping_list = get_first_customer_shopping_info
        if not customer_shopping_list.nil?
          session[:customer_shopping_list_name] = customer_shopping_list.shopping_list_name
        end
      end
      
    elsif not params[:set_customer_shopping_list].nil?
      # Changed current shopping list
      # Update to new shopping list
      session[:customer_shopping_list_name] = params[:set_customer_shopping_list]
          
    elsif not params[:add_to_list].nil?
      # Added an item to the current shopping list
      product_id = params[:add_to_list]      
      # First, make sure there is a shopping list to add to
      customer_id, customer_shopping_list = get_named_customer_shopping_info
      if not customer_id.nil? and not customer_shopping_list.nil?
        # If item already exists, add a count of 1 to current count
        if CustomerShoppingListItem.where(customer_shopping_list_id: customer_shopping_list.id, product_id: product_id).count > 0
          item = CustomerShoppingListItem.where(customer_shopping_list_id: customer_shopping_list.id, product_id: product_id).first
          item.quantity += 1
          item.save
        # else, add a new item with a count of 1
        else
          CustomerShoppingListItem.create(customer_shopping_list_id: customer_shopping_list.id, product_id: product_id, 
            quantity: 1, note: "")
        end
      end
          
    elsif not params[:delete_from_list].nil?
      # Added an item to the current shopping list
      product_id = params[:delete_from_list]
      # First, make sure there is a shopping list to add to
      customer_id, customer_shopping_list = get_named_customer_shopping_info
      if not customer_id.nil? and not customer_shopping_list.nil?
        # Delete item if we can find it
        if CustomerShoppingListItem.where(customer_shopping_list_id: customer_shopping_list.id, product_id: product_id).count > 0
          item = CustomerShoppingListItem.where(customer_shopping_list_id: customer_shopping_list.id, product_id: product_id).first
          item.destroy
        end
      end
      
    elsif not params[:commit].nil?
      if params[:commit] == "Rename Current List"
        customer_id, customer_shopping_list = get_named_customer_shopping_info
        if not customer_id.nil? and not customer_shopping_list.nil?
          if session[:customer_shopping_list_name] == params[:shopping_list_name]
            redirect_to store_path, notice: "No change in shopping list name."
            #flash[:notice] = "No change in shopping list name."
          else
            if CustomerShoppingList.where(shopping_list_name: params[:shopping_list_name]).count > 0
              redirect_to store_path, notice: "Can't rename to #{params[:shopping_list_name]} - already used."
            else
              customer_shopping_list.shopping_list_name = params[:shopping_list_name]
              customer_shopping_list.save
              session[:customer_shopping_list_name] = params[:shopping_list_name]
            end
          end
        else
          redirect_to store_path, notice: "Nothing to rename."
          #flash[:notice] = "Nothing to rename."
        end
        
      elsif params[:commit] == "Create New Shopping List"
        if not params[:shopping_list_name].blank?
          session[:customer_shopping_list_name] = params[:shopping_list_name]
          customer_id, customer_shopping_list = get_named_customer_shopping_info
          if not customer_id.nil? and not customer_shopping_list.nil?
            redirect_to store_path, notice: "Shopping list '#{session[:customer_shopping_list_name]}' already exists."
            #flash[:notice] = "Shopping list '#{session[:customer_shopping_list_name]}' already exists."
          else
            CustomerShoppingList.create(customer_id: customer_id, shopping_list_name: session[:customer_shopping_list_name])
          end
        else
          redirect_to store_path, notice: "No name given for new shopping list."
          #flash[:notice] = "No name given for new shopping list."
        end
        
      elsif params[:commit] == "Delete Current List"
        session[:customer_shopping_list_name] = params[:shopping_list_name]
        customer_id, customer_shopping_list = get_named_customer_shopping_info
        if not customer_id.nil? and not customer_shopping_list.nil?
          customer_shopping_list.destroy
          customer_id, customer_shopping_list = get_first_customer_shopping_info
          if not customer_shopping_list.nil?
            session[:customer_shopping_list_name] = customer_shopping_list.shopping_list_name
          end
        else
          redirect_to store_path, notice: "Nothing to delete."
          #flash[:notice] = "Nothing to delete."
        end
        
      elsif params[:commit] == "Change"
        # logger.debug params
        params.each do |key, new_value|
          if key =~ /^set_change_qty_/
            product_id = key["set_change_qty_".size..-1].to_i
            # logger.debug "set_change_qty_ search: #{key} = #{new_value}, p_id=#{product_id}"
            
            customer_id, customer_shopping_list = get_named_customer_shopping_info
            # logger.debug "customer_id #{customer_id}, customer_shopping_list #{customer_shopping_list}"
            if not customer_id.nil? and not customer_shopping_list.nil?
              # logger.debug "customer_id and customer_shopping_list not nil"
              # If item already exists, add a count of 1 to current count
              if CustomerShoppingListItem.where(customer_shopping_list_id: customer_shopping_list.id, product_id: product_id).count > 0
                # logger.debug "Got the CustomerShoppingListItem"
                item = CustomerShoppingListItem.where(customer_shopping_list_id: customer_shopping_list.id, product_id: product_id).first
                item.quantity = new_value
                item.save
                # logger.debug "item: #{item.to_s}"
              end
            end            
          end
        end
      end

    end
    
    # ************************************************************
    # Determine what products to display
    # ************************************************************
    # Check for a change in category, sub_category, and sub_category_group. We'll only get one.
    # Pull products for new situation
    if not params[:category].blank?
      session[:category] = params[:category]
      session[:sub_category] = ""
      session[:sub_category_group] = ""
      #@products = nil
      @products = Product.where(category: session[:category]).order(:sku)
    elsif not params[:sub_category].blank?
      session[:sub_category] = params[:sub_category]
      session[:sub_category_group] = ""
      @products = Product.where(category: session[:category], sub_category: session[:sub_category]).order(:sku)
    elsif not params[:sub_category_group].blank?
      session[:sub_category_group] = params[:sub_category_group]
      @products = Product.where(category: session[:category], sub_category: session[:sub_category], sub_category_group: session[:sub_category_group]).order(:sku)

    else
      # No changes in category, sub_category, and sub_category_group
      # Figure out what we displayed last using session category, sub_category, and sub_category_group
      if not session[:sub_category_group].blank?
        @products = Product.where(category: session[:category], sub_category: session[:sub_category], sub_category_group: session[:sub_category_group]).order(:sku)
      elsif not session[:sub_category].blank?
        @products = Product.where(category: session[:category], sub_category: session[:sub_category]).order(:sku)
      else
        @products = Product.where(category: session[:category]).order(:sku)
        #@products = nil
      end
    end
    
    # ************************************************************
    # Determine what to dipsplay in the product category,
    # sub_category, and sub_category_group list
    # ************************************************************
    # Determine what we'll display in the left hand margin
    logger.debug "session[:category] = #{session[:category]}"
    conn = ActiveRecord::Base.connection
    @categories = conn.select_values("select distinct category from products")
    @sub_categories = conn.select_values("select distinct sub_category from products where category #{equal_or_is_null(session[:category])}")
    @sub_category_groups = conn.select_values("select distinct sub_category_group from products where category #{equal_or_is_null(session[:category])} and sub_category #{equal_or_is_null(session[:sub_category])}")
    @cur_category = session[:category]
    @cur_sub_category = session[:sub_category]
    
    # ************************************************************
    # Setup the customer list
    @customers = Customer.select(:email).order(:email)
    @customer_email = ""
    if not session[:customer_email].blank?
      @customer_email = session[:customer_email]
      customer_id = Customer.where(email: session[:customer_email]).first.id
    end

    # ************************************************************
    # Setup the shopping lists for the current customers
    @customer_shopping_lists = CustomerShoppingList.where(customer_id: customer_id).order(:shopping_list_name)
    @cur_shopping_list = nil
    if not session[:customer_shopping_list_name].nil?
      customer_shopping_list = CustomerShoppingList.
        where(customer_id: customer_id, shopping_list_name: session[:customer_shopping_list_name]).order(:shopping_list_name).first
      if not customer_shopping_list.nil?
        @cur_shopping_list_id = customer_shopping_list.id
        @cur_shopping_list = customer_shopping_list.shopping_list_name
        customer_shopping_list_id = customer_shopping_list.id
        @customer_shopping_list_items = CustomerShoppingListItem.where(id: customer_shopping_list_id)
        
        @customer_shopping_list_items = conn.select_all(
          "select P.*, CSLI.quantity, CSLI.note
           from customer_shopping_list_items CSLI
             inner join products P on CSLI.product_id = P.id
           where CSLI.customer_shopping_list_id = #{customer_shopping_list_id}
           order by P.category, P.sub_category, P.sub_category_group, P.brand, P.descr"
        )
      end
    end

  end
  
  private
  
  def get_first_customer_shopping_info
    customer_id = Customer.where(email: session[:customer_email]).first.id
    # First, make sure there is a shopping list to add to
    if CustomerShoppingList.where(customer_id: customer_id).count > 0
      customer_shopping_list = CustomerShoppingList.where(customer_id: customer_id).order(:shopping_list_name).first
      return [customer_id, customer_shopping_list]
    end
    return [customer_id, nil]
  end
  
  def get_named_customer_shopping_info
    customer_id = Customer.where(email: session[:customer_email]).first.id
    # First, make sure there is a shopping list to add to
    if CustomerShoppingList.where(customer_id: customer_id).count > 0
      customer_shopping_list = CustomerShoppingList.where(customer_id: customer_id, 
          shopping_list_name: session[:customer_shopping_list_name]).first
      return [customer_id, customer_shopping_list]
    end
    return [customer_id, nil]
  end
  
  def equal_or_is_null(val)
    if val.nil?
      return "IS NULL"
    else
      return "= '#{val.to_s}'"
    end
    
  end

end
