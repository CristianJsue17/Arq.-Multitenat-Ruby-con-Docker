class ApplicationController < ActionController::Base
  helper_method :authenticate_user!
  helper_method :current_user
  helper_method :current_tenant

  before_action :set_current_tenant
  before_action :initialize_cart

  def authenticate_user!
    unless session[:user_id]
      redirect_to login_path, alert: "Debes iniciar sesión"
    end
  end

  def current_user
    @current_user ||= User.for_current_tenant.find_by(id: session[:user_id]) if session[:user_id]
  end

  def current_tenant
    @current_tenant
  end

  private

  def set_current_tenant
    subdomain = request.subdomain
    @current_tenant = Tenant.find_by(subdomain: subdomain)
    Tenant.current = @current_tenant
  end

  def initialize_cart
    if session[:user_id].present?
      @cart ||= Cart.find_by(user_id: session[:user_id])

      if session[:cart_id] && @cart.nil?
        @cart = Cart.find_by(id: session[:cart_id])
      elsif @cart.nil?
        @cart = Cart.create(user_id: session[:user_id])
      end

      return
    end

    @cart ||= Cart.find_by(id: session[:cart_id])

    if @cart.nil?
      @cart = Cart.create
      session[:cart_id] = @cart.id
    end
  end
end
