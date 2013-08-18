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
    @login = Login.new :email => params[:email],
      :password => params[:password]

    redirect_to root_path if @login.save

    return # stops double render
  end

  # POST /logout
  def logout
    @login.destroy

    redirect_to root_path
  end
end
