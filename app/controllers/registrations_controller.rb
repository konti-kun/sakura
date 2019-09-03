class RegistrationsController < Devise::RegistrationsController
  def index

  end

  def edit_password
    @user = User.find(current_user.id)
  end

  def update_password
    @user = User.find(current_user.id)
    params = account_update_params
    result = @user.update_with_password(params)
    if result
      redirect_to controller: 'home', action: 'index'
    else
      render action: 'edit_password'
    end
  end

  protected
  def update_resource(resource, params)
    if params["password"]&.present?
      super
    else
      resource.update_without_password(params)
    end
  end
end
