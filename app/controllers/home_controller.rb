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
    if params[:commit].eql? "Sign in"
      @login = Login.new :email => params[:email],
        :password => params[:password]

      flash[:notice] = "Wrong username/password" if not @login.save
      redirect_to root_path
    elsif params[:commit].eql? "Sign up"
      redirect_to new_user_path
    end
  end

  # POST /logout
  def logout
    @login.destroy

    redirect_to root_path
  end
end
