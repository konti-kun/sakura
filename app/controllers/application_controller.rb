class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    if resource.is_admin
      products_path
    else
      root_path
    end
  end

  protected

  def admin?
    authenticate_user!
    return if current_user.is_admin?

    flash[:notice] = 'admin権限が必要です。'
    redirect_to controller: 'home', action: 'index'
  end

  def end_user?
    authenticate_user!
    return unless current_user.is_admin?

    flash[:notice] = 'ログアウトして一般ユーザでログインしてください。'
    redirect_to controller: 'products', action: 'index'
  end

  def configure_permitted_parameters
    added_attrs = %i[email password password_confirmation is_admin]
    devise_parameter_sanitizer.permit :sign_up, keys: [end_user_attributes: %i[name address]]
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
  end
end
