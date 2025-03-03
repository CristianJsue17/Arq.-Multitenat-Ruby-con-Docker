class ProductsController < ApplicationController
  def index
    @products = Product.for_current_tenant
  end

  def show
    @product = Product.for_current_tenant.find(params[:id])
    @related_products = Product.for_current_tenant
                               .where(category: @product.category)
                               .where.not(id: @product.id)
                               .limit(4)
  
    # Detecta el subdominio y renderiza la vista adecuada
    if request.subdomain == "compufiis"
      render :show_compufiis
    elsif request.subdomain == "mueblesofi"
      render :show_muebleofi
    else
      render :show # Vista por defecto si no hay subdominio
    end
  end
  
  #para compufiis
  def laptops
    @products = Product.for_current_tenant.where(category: 'laptops')
    render :category_compufiis   #renderiza la vista de compufiis
  end

  def computadoras
    @products = Product.for_current_tenant.where(category: 'computadoras')
    render :category_compufiis
  end

  def celulares
    @products = Product.for_current_tenant.where(category: 'celulares')
    render :category_compufiis
  end

  def accesorios
    @products = Product.for_current_tenant.where(category: 'accesorios')
    render :category_compufiis
  end



  #para muebleofi
  def escritorios
    @products = Product.for_current_tenant.where(category: 'escritorios')
    render :category_muebleofi
  end
  
  def sillas
    @products = Product.for_current_tenant.where(category: 'sillas')
    render :category_muebleofi
  end
  
  def armarios
    @products = Product.for_current_tenant.where(category: 'armarios')
    render :category_muebleofi
  end
  
end
