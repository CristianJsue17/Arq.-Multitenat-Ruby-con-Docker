class HomeController < ApplicationController
  def index
    # Vista por defecto
    @message = "Bienvenidos a nuestra tienda principal!"
  end

  def compufiis
    @random_laptops = Product.for_current_tenant.where(category: 'laptops').order('RANDOM()').limit(2)
    @random_computers = Product.for_current_tenant.where(category: 'computadoras').order('RANDOM()').first
    @random_cellphones = Product.for_current_tenant.where(category: 'celulares').order('RANDOM()').limit(2)
    @random_cellphones = Product.for_current_tenant.where(category: 'accesorios').order('RANDOM()').first
    render "home/compufiis"
  end

  def mueblesofi
    @random_laptops = Product.for_current_tenant.where(category: 'sillas').order('RANDOM()').limit(2)
    @random_computers = Product.for_current_tenant.where(category: 'escritorios').order('RANDOM()').limit(2)
    @random_cellphones = Product.for_current_tenant.where(category: 'armarios').order('RANDOM()').limit(2)
    render "home/mueblesofi"
  end
end
