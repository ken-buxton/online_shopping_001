class SessionsController < ApplicationController
  skip_before_filter :authorize
  
  def new
  end

  def create
    customer = Customer.find_by_email(params[:email])
    if customer and customer.authenticate(params[:password])
      session[:customer_id] = customer.id
      session[:customer_email] = customer.email
      redirect_to '/store/index'
    else
      redirect_to login_url, notice: "Invalid customer/password combination."
    end
  end

  def destroy
    session[:customer_id] = nil
    session[:customer_email] = nil
    redirect_to login_url, notice: 'Logged out'
  end
end
