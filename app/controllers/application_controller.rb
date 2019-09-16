class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def is_admin?
    if not current_user&.is_admin?
      flash[:notice] = 'admin権限が必要です。'
      redirect_to controller: 'home', action: 'index'
    end
  end

  def configure_permitted_parameters
    added_attrs = [:email, :password, :password_confirmation, :is_admin]
    devise_parameter_sanitizer.permit :sign_up, keys: [end_user_attributes: [:name, :address]]
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
  end
end
