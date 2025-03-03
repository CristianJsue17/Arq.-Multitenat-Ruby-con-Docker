class CartsController < ApplicationController
  before_action :set_cart

  def show
    # Renderiza el carrito asociado al tenant actual
    @cart_items = @cart.cart_items.for_current_tenant
  end

  def create
    @product = Product.for_current_tenant.find(params[:product_id])
    quantity = params[:quantity].to_i
    current_cart_item = @cart.cart_items.for_current_tenant.find_by(product_id: @product.id)
  
    if current_cart_item && quantity > 0
      current_cart_item.update!(quantity: current_cart_item.quantity + quantity)
    elsif quantity <= 0 && current_cart_item
      current_cart_item.destroy!
    else
      @cart.cart_items.create!(product: @product, quantity: quantity, tenant: Tenant.current)
    end
  
    flash[:notice] = "#{@product.name} fue añadido al carrito."
    redirect_back(fallback_location: root_path_for_subdomain)
  end

  def destroy
    @cart_item = @cart.cart_items.for_current_tenant.find(params[:cart_item_id])
    @cart_item.destroy!

    flash[:notice] = "#{@cart_item.product.name} fue eliminado del carrito."
    redirect_back(fallback_location: root_path_for_subdomain)
  end

  private

  def set_cart
    # Encuentra o crea un carrito para el tenant actual
    @cart = Cart.for_current_tenant.find_or_create_by(id: session[:cart_id], tenant: Tenant.current)
    session[:cart_id] ||= @cart.id
  end

  def root_path_for_subdomain
    # Define el redireccionamiento según el subdominio
    case request.subdomain
    when "compufiis"
      compufiis_root_path
    when "mueblesofi"
      mueblesofi_root_path
    else
      root_path
    end
  end
end
