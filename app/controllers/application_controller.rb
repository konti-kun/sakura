class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    if resource.admin
      admin_products_path
    else
      root_path
    end
  end

  protected

  def authenticate_admin_user!
    authenticate_user!
    return if current_user.admin?

    flash[:notice] = 'admin権限が必要です。'
    redirect_to :root
  end

  def authenticate_end_user!
    authenticate_user!
    return unless current_user.admin?

    flash[:notice] = 'ログアウトして一般ユーザでログインしてください。'
    redirect_to admin_products_path
  end

  def configure_permitted_parameters
    added_attrs = %i[email password password_confirmation admin]
    devise_parameter_sanitizer.permit :sign_up, keys: [end_user_attributes: %i[name address]]
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
  end
end
