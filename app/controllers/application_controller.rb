class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :preferences

  def clean_preferences(choices, pref, default)
    return [params, cookies].inject(nil) do |value, config|
      value || config[pref] if !config[pref].nil? and choices.include? config[pref].to_sym
    end || default
  end

  def preferences
    @charset = clean_preferences([:simplified, :traditional], :charset, :simplified)
    @transcript = clean_preferences([:pinyin, :zhuyin, :jyutping], :transcript, :pinyin)
  end
end
