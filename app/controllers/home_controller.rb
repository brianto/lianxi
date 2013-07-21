class HomeController < ApplicationController
  # GET /
  def index
    @drills = Drill.find(:all)
    @passages = Passage.find(:all)
    @songs = Song.find(:all)
  end

  # GET /about
  def about
  end

  # POST /login
  def login
    session[:user] = params[:email] if params[:commit].eql? "Sign in"
    redirect_to root_path
  end

  # POST /logout
  def logout
    session[:user] = nil
    redirect_to root_path
  end
end
