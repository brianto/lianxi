class UsersController < ApplicationController
  def new
    @errors = Hash.new
    @new_user = User.new
  end

  def create
    @new_user = User.new user_params
    @errors = @new_user.errors

    if @new_user.save then
      @user = @new_user
      redirect_to user_path(@new_user)
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
