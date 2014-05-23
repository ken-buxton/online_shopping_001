class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  skip_before_filter :authorize, only: [:new, :create]

  # GET /customers
  # GET /customers.json
  def index
    #@customers = Customer.all
    @customers = Customer.where(id: session[:customer_id])
    #@customers = Customer.find(session[:customer_id])
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
    if session[:customer_id] and params[:id]
      if session[:customer_id].to_s != params[:id].to_s
        logger.debug "Attempt to edit other customer account (#{session[:customer_id]}, #{params[:id]})"
        redirect_to login_url, notice: "You attempted to edit another customer account."
      end
    else
      logger.debug "Invalid customer/password combination."
      redirect_to login_url, notice: "Invalid customer/password combination."
    end
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.save
        format.html { redirect_to @customer, 
          notice: "Customer #{@customer.email} was successfully created." }
        format.json { render action: "show", status: :created, location: @customer }
      else
        format.html { render action: "new" }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to @customer, 
          notice: "Customer #{@customer.email} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.require(:customer).permit(:id, :email, :password, :password_confirmation, 
        :preferred_store_id,
        :first_name, :last_name, :nick_name, 
        :home_phone, :cell_phone, 
        :address1, :city, :state_id, :zip
      )
    end
end
