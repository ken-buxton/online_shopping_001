class StoreController < ApplicationController
  
  def index
    # Parameter variables: :set_customer_email, :set_customer_shopping_list_name, :add_to_list, :delete_from_list, :commit, :shopping_list_name,
    #   :category, :sub_category, :sub_category_group
    #   :set_change_qty_x (where x is a multi-digit number)
    # 
    # Session variables: :category, :sub_category, :sub_category_group, :customer_shopping_list_name, :customer_email
    # 
    # Make sure all session variables have a value (nil if don't exist)
    session_vars = [:top_level, :category, :sub_category, :sub_category_group, 
      :customer_shopping_list_name, :customer_email,
      :customer_shopping_list_order, 
      :show_product_images, :show_category_info, 
      :search_value, :food_feature
    ]
    session_vars.each do |session_var|
      if session[session_var].nil?
        session[session_var] = ""
      end
    end
    
    if session[:show_product_images] == ""
      session[:show_product_images] == "yes"
    end
    
    if session[:customer_shopping_list_order] == ""
      session[:customer_shopping_list_order] == "*Category/Sub-category/Sub-category Group"
    end

    # ************************************************************
    # Handle changes to the current customer or 
    # current customer's shopping list.
    # ************************************************************
    if not params[:set_customer_email].nil?
      logger.debug ":set_customer_email"
      # Changed current customer
      # Set to new customer and reset previous category, sub_category, and sub_category_group
      session[:category] = ""
      session[:sub_category] = ""
      session[:sub_category_group] = ""
      session[:customer_shopping_list_name] = ""
      session[:search_value] = ""
      session[:food_feature] = ""
      if params[:set_customer_email].blank?
        session[:customer_email] = ""
      else
        session[:customer_email] = params[:set_customer_email]
        # Handle case where we just switched customers and they have a single shopping list
        customer_id, customer_shopping_list = get_first_customer_shopping_info(session[:customer_email])
        if not customer_shopping_list.nil?
          session[:customer_shopping_list_name] = customer_shopping_list.shopping_list_name
        end
      end
      
    elsif not params[:set_customer_shopping_list_name].nil?
      logger.debug ":set_customer_shopping_list_name"
      # Changed current shopping list
      # Update to new shopping list
      session[:customer_shopping_list_name] = params[:set_customer_shopping_list_name]
      
    elsif not params[:set_customer_shopping_list_order].nil?
      logger.debug ":set_customer_shopping_list_order"
      # Changed current shopping list
      # Update to new shopping list
      session[:customer_shopping_list_order] = params[:set_customer_shopping_list_order]
      
    elsif not params[:set_food_feature].nil?
      logger.debug ":set_food_feature"
      # Changed current shopping list
      # Update to new shopping list
      session[:food_feature] = params[:set_food_feature]
      
    elsif not params[:set_show_product_images_hidden].nil?
      logger.debug ":set_show_product_images_hidden"
      # check_box_tag will not send back a value parameter if 
      # Changed display product image
      # Update to new value (show/hide)
      if params[:set_show_product_images]
        session[:show_product_images] = "yes"
      else
        session[:show_product_images] = "no"
      end
          
    elsif not params[:set_show_category_info_hidden].nil?
      logger.debug ":set_show_category_info_hidden"
      # check_box_tag will not send back a value parameter if 
      # Changed display product image
      # Update to new value (show/hide)
      if params[:set_show_category_info]
        session[:show_category_info] = "yes"
      else
        session[:show_category_info] = "no"
      end
          
    elsif not params[:add_to_my_items].nil?
      logger.debug ":add_to_my_items"
      # Added an item to the current shopping list
      product_id = params[:add_to_my_items]      
      # First, make sure there is a shopping list to add to
      customer_id = get_customer_info(session[:customer_email])
      if not customer_id.nil?
        # If item already exists, add a count of 1 to current count
        if CustomerItem.where(customer_id: customer_id, product_id: product_id).count == 0
          CustomerItem.create(customer_id: customer_id, product_id: product_id, latest_reference_date: Time.now)
        end
      end
          
    elsif not params[:remove_from_my_items].nil?
      logger.debug ":remove_from_my_items"
      # Added an item to the current shopping list
      product_id = params[:remove_from_my_items]      
      # First, make sure there is a shopping list to add to
      customer_id = get_customer_info(session[:customer_email])
      if not customer_id.nil?
        # If item already exists, add a count of 1 to current count
        if CustomerItem.where(customer_id: customer_id, product_id: product_id).count > 0
          item = CustomerItem.where(customer_id: customer_id, product_id: product_id).first
          item.destroy
        end
      end
          
    elsif not params[:add_to_list].nil?
      logger.debug ":add_to_list"
      # Added an item to the current shopping list
      product_id = params[:add_to_list]      
      # First, make sure there is a shopping list to add to
      customer_id, customer_shopping_list = get_named_customer_shopping_info(session[:customer_email], session[:customer_shopping_list_name])
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
      logger.debug ":delete_from_list"
      # Added an item to the current shopping list
      product_id = params[:delete_from_list]
      # First, make sure there is a shopping list to add to
      customer_id, customer_shopping_list = get_named_customer_shopping_info(session[:customer_email], session[:customer_shopping_list_name])
      if not customer_id.nil? and not customer_shopping_list.nil?
        # Delete item if we can find it
        if CustomerShoppingListItem.where(customer_shopping_list_id: customer_shopping_list.id, product_id: product_id).count > 0
          item = CustomerShoppingListItem.where(customer_shopping_list_id: customer_shopping_list.id, product_id: product_id).first
          item.destroy
        end
      end
      
    elsif not params[:commit].nil?
      logger.debug ":commit=#{params[:commit]}"
      if params[:commit] == "Create"
        if not params[:shopping_list_name].blank?
          customer_id, customer_shopping_list = get_named_customer_shopping_info(session[:customer_email], params[:shopping_list_name])
          if not customer_id.nil? and not customer_shopping_list.nil?
            redirect_to store_path, notice: "Shopping list '#{params[:shopping_list_name]}' already exists."
          else
            session[:customer_shopping_list_name] = params[:shopping_list_name]
            CustomerShoppingList.create(customer_id: customer_id, shopping_list_name: session[:customer_shopping_list_name])
          end
        else
          redirect_to store_path, notice: "No name given for new shopping list."
        end
        
      elsif params[:commit] == "Rename"
        customer_id, customer_shopping_list = get_named_customer_shopping_info(session[:customer_email], session[:customer_shopping_list_name])
        if not customer_id.nil? and not customer_shopping_list.nil?
          if session[:customer_shopping_list_name] == params[:shopping_list_name]
            redirect_to store_path, notice: "No change in shopping list name."
          else
            if CustomerShoppingList.where(shopping_list_name: params[:shopping_list_name]).count > 0
              redirect_to store_path, notice: "Can't rename to #{params[:shopping_list_name]} - that name is already used."
            else
              customer_shopping_list.shopping_list_name = params[:shopping_list_name]
              customer_shopping_list.save
              session[:customer_shopping_list_name] = params[:shopping_list_name]
            end
          end
        else
          redirect_to store_path, notice: "Nothing to rename."
        end
        
      elsif params[:commit] == "Copy"
        if not params[:shopping_list_name].blank?
          customer_id, customer_shopping_list = get_named_customer_shopping_info(session[:customer_email], params[:shopping_list_name])
          if not customer_id.nil? and not customer_shopping_list.nil?
            redirect_to store_path, notice: "Copy to shopping list '#{session[:customer_shopping_list_name]}' already exists."
          else
            # Create the shopping list
            new_shopping_list_id = CustomerShoppingList.create(customer_id: customer_id, shopping_list_name: params[:shopping_list_name]).id
            # Copy the items from the old list to the new list
            old_customer_id, old_customer_shopping_list = get_named_customer_shopping_info(session[:customer_email], session[:customer_shopping_list_name])
            if not old_customer_id.nil? and not old_customer_shopping_list.nil?
              CustomerShoppingListItem.where(customer_shopping_list_id: old_customer_shopping_list.id).each do |shopping_list_item|
                CustomerShoppingListItem.create(customer_shopping_list_id: new_shopping_list_id, product_id: shopping_list_item.product_id,
                  quantity: shopping_list_item.quantity, note: shopping_list_item.note)
              end
              session[:customer_shopping_list_name] = params[:shopping_list_name]
            end
          end
        else
          redirect_to store_path, notice: "No name given for copied shopping list."
        end
        
      elsif params[:commit] == "Merge"
        if not params[:shopping_list_name].blank?
          if params[:shopping_list_name] ==session[:customer_shopping_list_name]
            redirect_to store_path, notice: "Can't merge a shopping list into itself."
          else
            # Get the merge to shopping list info
            merge_to_customer_id, merge_to_customer_shopping_list = get_named_customer_shopping_info(session[:customer_email], params[:shopping_list_name])
            if merge_to_customer_id.nil? or merge_to_customer_shopping_list.nil?
              redirect_to store_path, notice: "Merge to shopping list '#{params[:shopping_list_name]}' must already exist."
            else
              # Get the merge from shopping list info
              merge_from_customer_id, merge_from_customer_shopping_list = get_named_customer_shopping_info(session[:customer_email], session[:customer_shopping_list_name])
              # Copy the items from the old list to the new list
              if not merge_from_customer_id.nil? and not merge_from_customer_shopping_list.nil?
                CustomerShoppingListItem.where(customer_shopping_list_id: merge_from_customer_shopping_list.id).each do |from_shopping_list_item|
                  if CustomerShoppingListItem.where(customer_shopping_list_id: merge_to_customer_shopping_list.id,
                      product_id: from_shopping_list_item.product_id).count == 0
                    CustomerShoppingListItem.create(customer_shopping_list_id: merge_to_customer_shopping_list.id, product_id: from_shopping_list_item.product_id,
                      quantity: from_shopping_list_item.quantity, note: from_shopping_list_item.note)
                  else
                    csli = CustomerShoppingListItem.where(customer_shopping_list_id: merge_to_customer_shopping_list.id,
                      product_id: from_shopping_list_item.product_id).first
                    csli.quantity += from_shopping_list_item.quantity
                    if not csli.note.blank?
                      csli.note += ", " + from_shopping_list_item.note
                    end
                    csli.save
                  end
                end
                CustomerShoppingList.where(id: merge_from_customer_shopping_list.id).first.destroy
                session[:customer_shopping_list_name] = params[:shopping_list_name]
              else
                redirect_to store_path, notice: "Merge from shopping list '#{session[:customer_shopping_list_name]}' must already exist."
              end
            end
          end
        else
          redirect_to store_path, notice: "No name given for merged shopping list."
        end
        
      elsif params[:commit] == "Delete"
        session[:customer_shopping_list_name] = params[:shopping_list_name]
        customer_id, customer_shopping_list = get_named_customer_shopping_info(session[:customer_email], session[:customer_shopping_list_name])
        if not customer_id.nil? and not customer_shopping_list.nil?
          customer_shopping_list.destroy
          customer_id, customer_shopping_list = get_first_customer_shopping_info(session[:customer_email])
          if not customer_shopping_list.nil?
            session[:customer_shopping_list_name] = customer_shopping_list.shopping_list_name
          end
        else
          redirect_to store_path, notice: "Nothing to delete."
        end
        
      # elsif params[:commit] == "Change Qty"
        # params.each do |key, new_value|
          # if key =~ /^set_change_qty_/
            # product_id = key["set_change_qty_".size..-1].to_i
#             
            # customer_id, customer_shopping_list = get_named_customer_shopping_info(session[:customer_email], session[:customer_shopping_list_name])
            # if not customer_id.nil? and not customer_shopping_list.nil?
              # # If item already exists, add a count of 1 to current count
              # if CustomerShoppingListItem.where(customer_shopping_list_id: customer_shopping_list.id, product_id: product_id).count > 0
                # item = CustomerShoppingListItem.where(customer_shopping_list_id: customer_shopping_list.id, product_id: product_id).first
                # item.quantity = new_value
                # item.save
              # end
            # end            
          # end
        # end
#         
      # elsif params[:commit] == "Change Note"
        # params.each do |key, new_value|
          # if key =~ /^set_change_note_/
            # product_id = key["set_change_note_".size..-1].to_i
            # logger.debug "product_id=#{product_id}"
#             
            # customer_id, customer_shopping_list = get_named_customer_shopping_info(session[:customer_email], session[:customer_shopping_list_name])
            # if not customer_id.nil? and not customer_shopping_list.nil?
              # # If item already exists, add a count of 1 to current count
              # if CustomerShoppingListItem.where(customer_shopping_list_id: customer_shopping_list.id, product_id: product_id).count > 0
                # item = CustomerShoppingListItem.where(customer_shopping_list_id: customer_shopping_list.id, product_id: product_id).first
                # item.note = new_value
                # item.save
              # end
            # end            
          # end
        # end
        
      elsif params[:commit] == "Search"
        session[:search_value] = params[:search_value]
      elsif params[:commit] == "Clear"
        session[:search_value] = ""
                
      end

    else  # no static params - try the variable params
      logger.debug "No static params changes - check for: set_change_qty_xxx and set_change_note_xxx"
      # check for Change Qty
      params.each do |key, new_value|
        if key =~ /^set_change_qty_/
          product_id = key["set_change_qty_".size..-1].to_i
          logger.debug "param_key=#{key}, product_id=#{product_id}"
          
          customer_id, customer_shopping_list = get_named_customer_shopping_info(session[:customer_email], session[:customer_shopping_list_name])
          if not customer_id.nil? and not customer_shopping_list.nil?
            # If item already exists, add a count of 1 to current count
            if CustomerShoppingListItem.where(customer_shopping_list_id: customer_shopping_list.id, product_id: product_id).count > 0
              item = CustomerShoppingListItem.where(customer_shopping_list_id: customer_shopping_list.id, product_id: product_id).first
              item.quantity = new_value
              item.save
            end
          end            
        end
      end
      
      params.each do |key, new_value|
        if key =~ /^set_change_note_/
          product_id = key["set_change_note_".size..-1].to_i
          logger.debug "param_key=#{key}, product_id=#{product_id}"
          
          customer_id, customer_shopping_list = get_named_customer_shopping_info(session[:customer_email], session[:customer_shopping_list_name])
          if not customer_id.nil? and not customer_shopping_list.nil?
            # If item already exists, add a count of 1 to current count
            if CustomerShoppingListItem.where(customer_shopping_list_id: customer_shopping_list.id, product_id: product_id).count > 0
              item = CustomerShoppingListItem.where(customer_shopping_list_id: customer_shopping_list.id, product_id: product_id).first
              item.note = new_value
              item.save
            end
          end            
        end
      end
    end

    
    # ************************************************************
    # Setup the customer list
    @customers = Customer.select(:email).order(:email)
    @customer_email = ""
    customer_id = nil
    if not session[:customer_email].blank?
      @customer_email = session[:customer_email]
      customer_id = Customer.where(email: session[:customer_email]).first.id
    end
    
    # ************************************************************
    # Setup the food features list
    @food_features = FoodFeature.select(:name).order(:name)
    #@food_features = Customer.select(:email).order(:email)
    @cur_food_feature = ""
    if not session[:food_feature].blank?
      @cur_food_feature = session[:food_feature]
    end
    
    # ************************************************************
    # Set up top levels
    # ************************************************************
    conn = ActiveRecord::Base.connection
    @categories = []
    @sub_categories = []
    @sub_category_group = []
    
    @top_levels = ["My Items", "Sale Items", "Featured Items", "All Items"]
    logger.debug "params[:top_level]=#{params[:top_level]}"
    if not params[:top_level].blank?
      session[:top_level] = params[:top_level]
      session[:category] = ""
      session[:sub_category] = ""
      session[:sub_category_group] = ""
      logger.debug "session[:top_level]=#{session[:top_level]}"
    end
    @search_value = session[:search_value]
    
    @cur_top_level = session[:top_level]
    @shopping_header = @cur_top_level
    logger.debug "@cur_top_level=#{@cur_top_level}"
    if @cur_top_level == "My Items"
      @products = Product.where("id in (select product_id from customer_items where customer_id = #{customer_id})").order(:category, :sub_category, :sub_category_group)
      
    elsif @cur_top_level == "Sale Items"
      @products = Product.where("on_sale = 't'").order(:category, :sub_category, :sub_category_group)
              
    elsif @cur_top_level == "Featured Items"
      @products = Product.where("featured_item = 't'").order(:category, :sub_category, :sub_category_group)
                    
    elsif @cur_top_level == "All Items"

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
        @shopping_header += " > #{session[:category]}"
      elsif not params[:sub_category].blank?
        session[:sub_category] = params[:sub_category]
        session[:sub_category_group] = ""
        @products = Product.where(category: session[:category], sub_category: session[:sub_category]).order(:sku)
        @shopping_header += " > #{session[:category]} > #{session[:sub_category]}"
      elsif not params[:sub_category_group].blank?
        session[:sub_category_group] = params[:sub_category_group]
        @products = Product.where(category: session[:category], sub_category: session[:sub_category], sub_category_group: session[:sub_category_group]).order(:sku)
        @shopping_header += " > #{session[:category]} > #{session[:sub_category]} > #{session[:sub_category_group]}"
  
      else
        # No changes in category, sub_category, and sub_category_group
        # Figure out what we displayed last using session category, sub_category, and sub_category_group
        if not session[:sub_category_group].blank?
          @products = Product.where(category: session[:category], sub_category: session[:sub_category], sub_category_group: session[:sub_category_group]).order(:sku)
          @shopping_header += " > #{session[:category]} > #{session[:sub_category]} > #{session[:sub_category_group]}"
        elsif not session[:sub_category].blank?
          @products = Product.where(category: session[:category], sub_category: session[:sub_category]).order(:sku)
          @shopping_header += " > #{session[:category]} > #{session[:sub_category]}"
        elsif not session[:category].blank?
          @products = Product.where(category: session[:category]).order(:sku)
          @shopping_header += " > #{session[:category]}"
        else
          @products = Product.order(:sku)
        end
      end
    
      # ************************************************************
      # Determine what to dipsplay in the product category,
      # sub_category, and sub_category_group list
      # ************************************************************
      # Determine what we'll display in the left hand margin
      @categories = conn.select_values(
        "select distinct category 
        from products 
        order by category")
      @sub_categories = conn.select_values(
        "select distinct sub_category 
        from products 
        where category #{equal_or_is_null(session[:category])} 
        order by sub_category")
      @sub_category_groups = conn.select_values(
        "select distinct sub_category_group 
        from products 
        where category #{equal_or_is_null(session[:category])}
          and sub_category #{equal_or_is_null(session[:sub_category])} 
          order by sub_category_group")
      @cur_category = session[:category]
      @cur_sub_category = session[:sub_category]
      
    end
    
    # ************************************************************
    # At this point the list of products has been defined. Now add
    # the search criteria
    if @search_value != ""
      @products = @products.where(%Q~lower(brand || "descr") like lower('%#{@search_value}%')~)
    end
    if @cur_food_feature != ""
      @products = @products.where("food_feature = '#{@cur_food_feature}'")      
    end
    
    # ************************************************************
    @show_product_images = true
    if session[:show_product_images] == "yes" 
      @show_product_images = true
    elsif session[:show_product_images] == "no" 
      @show_product_images = false
    end

    # ************************************************************
    @show_category_info = true
    if session[:show_category_info] == "yes" 
      @show_category_info = true
    elsif session[:show_category_info] == "no" 
      @show_category_info = false
    end

    # ************************************************************
    # Setup the shopping lists for the current customers
    @customer_shopping_list_orders = ["*Category/Sub-category/Sub-category Group",
      "Price - Ascending", "Price - Descending", 
      "Ext Price - Ascending", "Ext Price - Descending", 
      "Brand/Description", "Description"]
    @cur_shopping_list_order = session[:customer_shopping_list_order]
      
    @customer_shopping_lists = CustomerShoppingList.where(customer_id: customer_id).order(:shopping_list_name)
    @cur_shopping_list = nil
    if not session[:customer_shopping_list_name].blank?
      customer_shopping_list = CustomerShoppingList.
        where(customer_id: customer_id, shopping_list_name: session[:customer_shopping_list_name]).order(:shopping_list_name).first
      if not customer_shopping_list.nil?
        @cur_shopping_list_id = customer_shopping_list.id
        @cur_shopping_list = customer_shopping_list.shopping_list_name
        customer_shopping_list_id = customer_shopping_list.id
        @customer_shopping_list_items = CustomerShoppingListItem.where(id: customer_shopping_list_id)
        
        csl_order_by = ""
        if session[:customer_shopping_list_order] == "*Category/Sub-category/Sub-category Group"
          csl_order_by = "order by P.category, P.sub_category, P.sub_category_group, P.brand, P.descr"
        elsif session[:customer_shopping_list_order] == "Price - Ascending"
          csl_order_by = "order by P.price asc"
        elsif session[:customer_shopping_list_order] == "Price - Descending"
          csl_order_by = "order by P.price desc"
        elsif session[:customer_shopping_list_order] == "Ext Price - Ascending"
          csl_order_by = "order by P.price * CSLI.quantity asc"
        elsif session[:customer_shopping_list_order] == "Ext Price - Descending"
          csl_order_by = "order by P.price * CSLI.quantity desc"
        elsif session[:customer_shopping_list_order] == "Brand/Description"
          csl_order_by = "order by P.brand || P.descr"
        elsif session[:customer_shopping_list_order] == "Description"
          csl_order_by = "order by P.descr"
        else
          csl_order_by = ""
        end
        @customer_shopping_list_items = conn.select_all(
          "select P.*, CSLI.quantity, CSLI.note
           from customer_shopping_list_items CSLI
             inner join products P on CSLI.product_id = P.id
           where CSLI.customer_shopping_list_id = #{customer_shopping_list_id} #{csl_order_by} "
        )
      end
    end

  end
  
  private
  
  def get_customer_info(email)
    customer_id = Customer.where(email: email).first.id
  end
  
  def get_first_customer_shopping_info(email)
    customer_id = Customer.where(email: email).first.id
    # First, make sure there is a shopping list to add to
    if CustomerShoppingList.where(customer_id: customer_id).count > 0
      customer_shopping_list = CustomerShoppingList.where(customer_id: customer_id).order(:shopping_list_name).first
      return [customer_id, customer_shopping_list]
    end
    return [customer_id, nil]
  end
  
  def get_named_customer_shopping_info(email, customer_shopping_list_name)
    customer_id = Customer.where(email: email).first.id
    # First, make sure there is a shopping list to add to
    if CustomerShoppingList.where(customer_id: customer_id).count > 0
      customer_shopping_list = CustomerShoppingList.where(customer_id: customer_id, 
          shopping_list_name: customer_shopping_list_name).first
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
