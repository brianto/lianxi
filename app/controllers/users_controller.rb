class UsersController < ApplicationController
  def new
    @new_user = User.new
  end

  def create
    @new_user = User.new user_params

    if @new_user.save then
      @user = @new_user
      redirect_to user_path(@user)
    else
      render "new"
    end
  end

  def show
    @show_user = User.find params[:id]

    redirect_to root_path unless @show_user.eql? @user
  end

  def edit

  end

  def update

  end

  def destroy

  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
