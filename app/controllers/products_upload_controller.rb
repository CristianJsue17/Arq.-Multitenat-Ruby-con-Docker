class ProductsUploadController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:edit, :update, :destroy, :show]

  # Acción para crear un nuevo producto
  def new
    @product = Product.new
    @products_by_category = Product.for_current_tenant.group_by(&:category) # Filtrar por tenant actual
    if request.subdomain == "compufiis"
      render :admin_compufiis
    elsif request.subdomain == "mueblesofi"
      render :admin_muebleofi
    else
      render :new # Renderiza una vista genérica si no hay subdominio
    end
  end
  

  # Acción para guardar un nuevo producto
  def create
    @product = Product.new(product_params)
    @product.tenant = Tenant.current
  
    if @product.save
      redirect_to new_products_upload_path, notice: 'Producto cargado exitosamente.'
    else
      @products_by_category = Product.for_current_tenant.group_by(&:category)
      case request.subdomain
      when "compufiis"
        render :admin_compufiis
      when "mueblesofi"
        render :admin_muebleofi
      else
        render :new
      end
    end
  end
  

  # Acción para editar un producto
  def edit
    set_product # Asegúrate de que el producto esté correctamente definido
  
    if request.subdomain == "compufiis"
      render :edit_compufiis
    elsif request.subdomain == "mueblesofi"
      render :edit_muebleofi
    else
      render :edit # Renderiza una vista genérica en caso de no identificar el subdominio
    end
  end
  

  # Acción para actualizar un producto
def update
  @product = Product.for_current_tenant.find_by(id: params[:id]) # Filtra por tenant actual
  if @product.nil?
    redirect_to new_products_upload_path, alert: 'No se pudo encontrar el producto o no pertenece al tenant actual.'
    return
  end

  if @product.update(product_params)
    redirect_to new_products_upload_path, notice: 'Producto actualizado exitosamente.'
  else
    case request.subdomain
    when "compufiis"
      render :edit_compufiis
    when "mueblesofi"
      render :edit_muebleofi
    else
      render :edit
    end
  end
end


 # Acción para eliminar un producto
def destroy
  @product = Product.for_current_tenant.find_by(id: params[:id]) # Filtra por tenant actual
  if @product.nil?
    redirect_to new_products_upload_path, alert: 'No se pudo encontrar el producto o no pertenece al tenant actual.'
    return
  end

  # Elimina todas las referencias al producto en cart_items
  CartItem.where(product_id: @product.id).destroy_all

  # Elimina todas las referencias al producto en order_details
  OrderDetail.where(product_id: @product.id).destroy_all

  # Elimina la imagen adjunta, si existe
  @product.image.purge if @product.image.attached?

  # Intenta eliminar el producto
  if @product.destroy
    redirect_to new_products_upload_path, notice: 'Producto eliminado exitosamente.'
  else
    redirect_to new_products_upload_path, alert: 'No se pudo eliminar el producto.'
  end
end



  # Acción para mostrar los detalles de un producto
  def show
    # Rails renderiza automáticamente la vista `show.html.erb`
    # No lo estamos usando
  end

  private

  # Parámetros permitidos para un producto
  def product_params
    params.require(:product).permit(:name, :description, :price, :category, :brand, :stock, :material, :dimension, :peso, :color, :caracteristicas, :image)
  end

  # Encuentra el producto usando el :id de los parámetros
  def set_product
    @product = Product.for_current_tenant.find(params[:id]) # Filtra por tenant actual
  end
end
