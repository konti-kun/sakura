class RegistrationsController < Devise::RegistrationsController
  def new
    @user = User.new
    @user.build_end_user
  end
end
