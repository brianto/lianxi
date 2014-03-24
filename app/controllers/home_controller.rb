class HomeController < ApplicationController
  def index
    def groupings_for(model_class)
      groupings = Hash.new

      groupings[:pinned] = if @user
        @user.pins
          .pinned
          .where(:teachable_type => model_class)
          .order(:created_at)
          .take(5)
          .map(&:teachable)
      else
        []
      end

      groupings[:mine] = model_class
        .where(:user_id => @user)
        .order(:created_at)
        .take(5)

      groupings[:newest] = model_class
        .all
        .order(:created_at)
        .take(5)

      [:pinned, :mine, :newest].inject(Array.new) do |seen, scope|
        groupings[scope] -= seen
        seen += groupings[scope]
      end

      groupings
    end

    @drills = groupings_for Drill
    @passages = groupings_for Passage
    @songs = groupings_for Song
  end

  # GET /about
  def about
  end

  # POST /login
  def login
    if params[:commit].eql? "Sign in"
      @login = Login.new :email => params[:email], :password => params[:password]

      begin
        @login.save!
      rescue Exception => e
        flash[:notice] = e.to_s
        raise e
      end

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
