class Admin::UsersController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_user, only: %w[edit update destroy]

  def index
    @users = User.includes(:end_user).where(admin: false).order('id').page(params[:page]).per(20)
  end

  def update
    if @user.update(user_params)
      redirect_to action: 'index', notice: 'ユーザを更新しました。'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy!
    redirect_to action: 'index', notice: 'ユーザを削除しました。'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, end_user_attributes: %i[id name address])
  end
end
