class StoreController < ApplicationController
  # *************************************************************************************************
  # Page layout. The page is divided into three primary columns:
  # *************************************************************************************************
  #   1) Item view selection (left column) - this column of allows the user to select the items they
  #      want to view.
  #   2) Item view (middle column) - this column shows the currently requested set of items for the
  #      user to shop from.
  #   3) Shopping list selector and current shopping items (right column)
  # 
  # Item view selection column:
  #   Details of controls
  # 
  # Item view column:
  #   Details of controls
  # 
  # Shopping list selector and current shopping items column:
  # 
  
  def index
    # *************************************************************************************************
    # Program layout. The "index" method of StoreController
    # *************************************************************************************************
    # 100.01) Initialization
    # 200.01) Handle changes to various controls on the store page
    # 300.01) Build required data structures for view processingt
    # 400.01) Response processing - based on value in index_render_method
    # 
    # 
   
    
    # Parameter variables: :set_customer_email, :set_customer_shopping_list_name, :add_to_list, :delete_from_list, :commit, :shopping_list_name,
    #   :category, :sub_category, :sub_category_group
    #   :set_change_qty_x (where x is a multi-digit number)
    # 
    # Session variables: :category, :sub_category, :sub_category_group, :customer_shopping_list_name, :customer_email
    # 
    # *************************************************************************************************
    # 100.01) Initialization
    # *************************************************************************************************
    # Make sure all session variables have a value (nil if don't exist)
    session_vars = [:top_level, :category, :sub_category, :sub_category_group, 
      :customer_shopping_list_name, :customer_email,
      :customer_shopping_list_order, 
      :show_product_images, :show_category_info, 
      :search_value, :food_feature, :cur_cust_item
    ]
    session_vars.each do |session_var|
      if session[session_var].nil?
        session[session_var] = ""
      end
      logger.debug "session[#{session_var}]=#{session[session_var]}"
    end

    # not sure why this is needed. It seems otherwise that the :notice is persisted longer than desired
    # (an Ajax issue?)
    flash[:notice] = nil
    
    # Things seem to still work with this code commented out. Leave here for now just in case.
    # if session[:show_product_images] == ""
      # session[:show_product_images] == "yes"
    # end
    
    customer_shopping_list_orders = ["*Category/Sub-category/Sub-category Group",
      "Price - Ascending", "Price - Descending", 
      "Ext Price - Ascending", "Ext Price - Descending", 
      "Brand/Description", "Description"]  
        
    if session[:customer_shopping_list_order] == ""
      session[:customer_shopping_list_order] == customer_shopping_list_orders[0]
    end
    
    @cur_cust_item = session[:cur_cust_item]
    index_render_method = ""

    # *************************************************************************************************
    # 200.01) Handle changes to various controls on the store page
    # *************************************************************************************************
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
      index_render_method = "index_cust_items"
      logger.debug ":set_customer_shopping_list_name"
      # Changed current shopping list
      # Update to new shopping list
      session[:customer_shopping_list_name] = params[:set_customer_shopping_list_name]
      
    elsif not params[:set_customer_shopping_list_order].nil?
      index_render_method = "index_cust_items"
      logger.debug ":set_customer_shopping_list_order"
      # Changed current shopping list
      # Update to new shopping list
      session[:customer_shopping_list_order] = params[:set_customer_shopping_list_order]
      
    elsif not params[:set_food_feature].nil?
      index_render_method = "index_shop_items"
      logger.debug ":set_food_feature"
      # Changed current shopping list
      # Update to new shopping list
      session[:food_feature] = params[:set_food_feature]
      if session[:food_feature] == "All"
        session[:food_feature] = ""
      end
      
    elsif not params[:set_show_product_images_hidden].nil?
      index_render_method = "index_shop_items"
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
      index_render_method = "index_shop_items"
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
      index_render_method = "index_cust_items"
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
          @cur_cust_item = "#cust_item_" + item.product_id.to_s
          logger.debug "@cur_cust_item=#{@cur_cust_item}"
        # else, add a new item with a count of 1
        else
          item = CustomerShoppingListItem.create(customer_shopping_list_id: customer_shopping_list.id, product_id: product_id, 
            quantity: 1, note: "")
          @cur_cust_item = "#cust_item_" + item.product_id.to_s
          logger.debug "@cur_cust_item=#{@cur_cust_item}"
        end
      end
          
    elsif not params[:delete_from_list].nil?
      index_render_method = "index_cust_items"
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
    
    # elsif any forms that returned a commit parameter (buttons)
    elsif not params[:commit].nil?
      
      if params[:commit] == "Create"
        index_render_method = "index_cust_items"
        if not params[:shopping_list_name].blank?
          customer_id, customer_shopping_list = get_named_customer_shopping_info(session[:customer_email], params[:shopping_list_name])
          if not customer_id.nil? and not customer_shopping_list.nil?
            flash[:notice] = "Can't create shopping list '#{params[:shopping_list_name]}' because it already exists."
          else
            session[:customer_shopping_list_name] = params[:shopping_list_name]
            CustomerShoppingList.create(customer_id: customer_id, shopping_list_name: session[:customer_shopping_list_name])
          end
        else
          flash[:notice] = "Can't create a new shopping list because a name was not supplied."
        end
        
      elsif params[:commit] == "Rename"
        index_render_method = "index_cust_items"
        if not params[:shopping_list_name].blank?
          customer_id, customer_shopping_list = get_named_customer_shopping_info(session[:customer_email], session[:customer_shopping_list_name])
          if not customer_id.nil? and not customer_shopping_list.nil?
            if session[:customer_shopping_list_name] == params[:shopping_list_name]
              flash[:notice] = "Can't rename shopping list '#{params[:shopping_list_name]}' because there was no change in the shopping list name."
            else
              if CustomerShoppingList.where(shopping_list_name: params[:shopping_list_name]).count > 0
                flash[:notice] = "Can't rename shopping list '#{session[:customer_shopping_list_name]}' to '#{params[:shopping_list_name]}' because that name is already used."
              else
                customer_shopping_list.shopping_list_name = params[:shopping_list_name]
                customer_shopping_list.save
                session[:customer_shopping_list_name] = params[:shopping_list_name]
              end
            end
          else
            # this should never occur
            flash[:notice] = "Can't rename the shopping list '#{session[:customer_shopping_list_name]}' because it does not exist."
          end
        else
          flash[:notice] = "Can't rename the shopping list '#{session[:customer_shopping_list_name]}' because a new name was not supplied."
        end
        
      elsif params[:commit] == "Copy"
        index_render_method = "index_cust_items"
        if not params[:shopping_list_name].blank?
          customer_id, customer_shopping_list = get_named_customer_shopping_info(session[:customer_email], params[:shopping_list_name])
          if not customer_id.nil? and not customer_shopping_list.nil?
            flash[:notice] = "Can't copy to shopping list '#{session[:customer_shopping_list_name]}' because it already exists."
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
          flash[:notice] = "Can't copy from '#{session[:customer_shopping_list_name]}' because a name to copy to was not supplied ."
       end
        
      elsif params[:commit] == "Merge"
        index_render_method = "index_cust_items"
        if not params[:shopping_list_name].blank?
          if params[:shopping_list_name] == session[:customer_shopping_list_name]
            flash[:notice] = "Can't merge from '#{session[:customer_shopping_list_name]}' because a different name to merge to was not supplied ."
         else
            # Get the merge to shopping list info
            merge_to_customer_id, merge_to_customer_shopping_list = get_named_customer_shopping_info(session[:customer_email], params[:shopping_list_name])
            if merge_to_customer_id.nil? or merge_to_customer_shopping_list.nil?
              flash[:notice] = "Can't merge to shopping list '#{params[:shopping_list_name]}' because it must already exist (try copy)."
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
                flash[:notice] = "Can't merge from shopping list '#{session[:customer_shopping_list_name]}' because it must already exist."
              end
            end
          end
        else
          flash[:notice] = "Can't merge from '#{session[:customer_shopping_list_name]}' because a name to merge to was not supplied .."
        end
        
      elsif params[:commit] == "Delete"
        index_render_method = "index_cust_items"
        session[:customer_shopping_list_name] = params[:shopping_list_name]
        customer_id, customer_shopping_list = get_named_customer_shopping_info(session[:customer_email], session[:customer_shopping_list_name])
        if not customer_id.nil? and not customer_shopping_list.nil?
          customer_shopping_list.destroy
          customer_id, customer_shopping_list = get_first_customer_shopping_info(session[:customer_email])
          if not customer_shopping_list.nil?
            session[:customer_shopping_list_name] = customer_shopping_list.shopping_list_name
          end
        else
          flash[:notice] = "Can't delete '#{params[:shopping_list_name]} because it does not exist."
        end
                
      elsif params[:commit] == "Search"
        index_render_method = "index_shop_items"
        session[:search_value] = params[:search_value]
      elsif params[:commit] == "Clear"
        index_render_method = "index_shop_items"
        session[:search_value] = ""
                
      end

    # elsif not params[:commit].nil?
    else  # no static params - try the variable params
      # Check for any parameters returned to change qty values
      params.each do |key, new_value|
        if key =~ /^set_change_qty_/
          index_render_method = "index_cust_items"
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
      
      # Check for any parameters returned to change note values
      params.each do |key, new_value|
        if key =~ /^set_change_note_/
          index_render_method = "index_cust_items"
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
          end   # if not customer_id.nil? and
        end     # if key =~
      end       # params.each do
      
    # elsif not params[:commit].nil?
    end

    
    # *************************************************************************************************
    # 300.01) Build required data structures for view processingt
    # *************************************************************************************************
    
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
      index_render_method = "index_shop_items"
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
        index_render_method = "index_shop_items"
        session[:category] = params[:category]
        session[:sub_category] = ""
        session[:sub_category_group] = ""
        #@products = nil
        @products = Product.where(category: session[:category]).order(:category, :sub_category, :sub_category_group, :sku)
        @shopping_header += " > #{session[:category]}"
      elsif not params[:sub_category].blank?
        index_render_method = "index_shop_items"
        session[:sub_category] = params[:sub_category]
        session[:sub_category_group] = ""
        @products = Product.where(category: session[:category], sub_category: session[:sub_category]).order(:category, :sub_category, :sub_category_group, :sku)
        @shopping_header += " > #{session[:category]} > #{session[:sub_category]}"
      elsif not params[:sub_category_group].blank?
        index_render_method = "index_shop_items"
        session[:sub_category_group] = params[:sub_category_group]
        @products = Product.where(category: session[:category], sub_category: session[:sub_category], sub_category_group: session[:sub_category_group]).order(:category, :sub_category, :sub_category_group, :sku)
        @shopping_header += " > #{session[:category]} > #{session[:sub_category]} > #{session[:sub_category_group]}"
  
      else
        # No changes in category, sub_category, and sub_category_group
        # Figure out what we displayed last using session category, sub_category, and sub_category_group
        if not session[:sub_category_group].blank?
          @products = Product.where(category: session[:category], sub_category: session[:sub_category], sub_category_group: session[:sub_category_group]).order(:category, :sub_category, :sub_category_group, :sku)
          @shopping_header += " > #{session[:category]} > #{session[:sub_category]} > #{session[:sub_category_group]}"
        elsif not session[:sub_category].blank?
          @products = Product.where(category: session[:category], sub_category: session[:sub_category]).order(:category, :sub_category, :sub_category_group, :sku)
          @shopping_header += " > #{session[:category]} > #{session[:sub_category]}"
        elsif not session[:category].blank?
          @products = Product.where(category: session[:category]).order(:category, :sub_category, :sub_category_group, :sku)
          @shopping_header += " > #{session[:category]}"
        else
          @products = Product.order(:category, :sub_category, :sub_category_group, :sku)
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
    logger.debug "@cur_food_feature=#{@cur_food_feature}"


    if not @products.nil?
      @shopping_header += " (#{@products.count})"
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
    @customer_shopping_list_orders = customer_shopping_list_orders
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
          csl_order_by = "order by P.category, P.sub_category, P.sub_category_group, P.brand, P.descr asc"
        elsif session[:customer_shopping_list_order] == "Price - Ascending"
          csl_order_by = "order by P.price asc"
        elsif session[:customer_shopping_list_order] == "Price - Descending"
          csl_order_by = "order by P.price desc"
        elsif session[:customer_shopping_list_order] == "Ext Price - Ascending"
          csl_order_by = "order by P.price * CSLI.quantity asc"
        elsif session[:customer_shopping_list_order] == "Ext Price - Descending"
          csl_order_by = "order by P.price * CSLI.quantity desc"
        elsif session[:customer_shopping_list_order] == "Brand/Description"
          csl_order_by = "order by P.brand || P.descr asc"
        elsif session[:customer_shopping_list_order] == "Description"
          csl_order_by = "order by P.descr asc"
        else
          csl_order_by = ""
        end
        @customer_shopping_list_items = conn.select_all(
          "select P.*, P.id as product_id, 
            CSLI.quantity, CSLI.note
           from customer_shopping_list_items CSLI
             inner join products P on CSLI.product_id = P.id
           where CSLI.customer_shopping_list_id = #{customer_shopping_list_id} #{csl_order_by} "
        )
      end
    end
    session[:cur_cust_item] = @cur_cust_item
    
    # *************************************************************************************************
    # 400.01) Response processing - based on value in index_render_method
    # *************************************************************************************************
    # index_render_method = "index_cust_items"
    logger.debug "index_render_method=#{index_render_method}"
    respond_to do |format|
      if not index_render_method.blank?
        format.js { render index_render_method }
      else
        format.html 
      end
    end

  # end of StoreController "index" method
  # *************************************************************************************************
  end
  # *************************************************************************************************
  
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
