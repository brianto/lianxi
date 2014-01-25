class ApplicationController < ActionController::Base
  protect_from_forgery

  # filter_parameter_logging :password, :password_confirmation

  before_action :authenticate

  def authenticate
    @login = Login.find

    if @login then
      @user = @login.record
    else
      @login = Login.new
      @user = nil
    end
  end

  def logged_in?
    !@user.nil?
  end

  def require_login
    unless logged_in? then
      flash[:notice] = "Insufficient permissions"
      redirect_to root_url
    end
  end
end
