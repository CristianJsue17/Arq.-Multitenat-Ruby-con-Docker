class AuthController < ApplicationController
  def new
    if request.subdomain == "compufiis"
      render :login_compufiis
    elsif request.subdomain == "mueblesofi"
      render :login_muebleofi
    else
      render :new # Vista por defecto
    end
  end

  def create
    user = User.for_current_tenant.find_by(username: params[:username]) # Asegúrate de usar el scope for_current_tenant
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to new_products_upload_path, notice: "Sesión iniciada correctamente"
    else
      flash.now[:alert] = "Usuario o contraseña incorrectos"
      if request.subdomain == "compufiis"
        render :login_compufiis
      elsif request.subdomain == "mueblesofi"
        render :login_muebleofi
      else
        render :new
      end
    end
  end

  def destroy
    session[:user_id] = nil
    if request.subdomain == "compufiis"
      redirect_to compufiis_root_path, notice: "Has cerrado sesión correctamente."
    elsif request.subdomain == "mueblesofi"
      redirect_to mueblesofi_root_path, notice: "Has cerrado sesión correctamente."
    else
      redirect_to root_path, notice: "Has cerrado sesión correctamente."
    end
  end
  
  
end
