class ApplicationController < ActionController::Base
  protect_from_forgery

  # filter_parameter_logging :password, :password_confirmation

  before_filter :preferences
  before_filter :authenticate

  def clean_preferences(choices, pref, default)
    return [params, cookies].inject(nil) do |value, config|
      value || config[pref] if !config[pref].nil? and choices.include? config[pref].to_sym
    end || default
  end

  def preferences
    @charset = clean_preferences([:simplified, :traditional], :charset, :simplified)
    @transcript = clean_preferences([:pinyin, :zhuyin, :jyutping], :transcript, :pinyin)
  end

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
