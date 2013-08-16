class UsersController < ApplicationController
  def new
    @user = User.new
    @errors = Hash.new
  end

  def create
    @user = User.new params[:user]
    @errors = @user.errors

    if @user.save then
      redirect_to user_path(@user)
    else
      render "new"
    end
  end

  def show
    @user = User.find params[:id]
  end

  def edit

  end

  def update

  end

  def destroy

  end
end
