class RegistrationsController < Devise::RegistrationsController
  def index

  end

  def new
    @user = User.new
    @user.build_end_user
  end

end
