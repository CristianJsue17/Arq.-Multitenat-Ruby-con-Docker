class OrdersController < ApplicationController
  before_action :set_cart

  def create
    ActiveRecord::Base.transaction do
      # Crea la orden asociada al tenant y al usuario
      order = Order.create!(
        user: User.first, # Reemplazar con el usuario autenticado
        tenant: Tenant.current,
        total: @cart.total
      )

      # Genera los detalles de la orden a partir de los ítems del carrito
      @cart.cart_items.for_current_tenant.each do |cart_item|
        OrderDetail.create!(
          order: order,
          product: cart_item.product,
          tenant: Tenant.current,
          quantity: cart_item.quantity,
          price: cart_item.product.price
        )
      end

      # Limpia el carrito después de finalizar la orden
      @cart.cart_items.destroy_all
      session[:cart_id] = nil
    end

    redirect_to root_path_for_subdomain, notice: "Orden creada exitosamente!"
  end

  private

  def set_cart
    # Encuentra el carrito del tenant actual
    @cart = Cart.for_current_tenant.find_by(id: session[:cart_id])

    unless @cart
      @cart = Cart.create!(tenant: Tenant.current)
      session[:cart_id] = @cart.id
    end
  end

  def root_path_for_subdomain
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
