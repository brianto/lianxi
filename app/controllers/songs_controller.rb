class SongsController < TeachablesController
  before_filter :setup_teachables

  def setup_teachables
    @model_class = Song
  end

  def index
    @songs = Song.find :all
  end

  def create
    @song = Song.new params[:songs]

    if !@song.save then
      flash["notice"] = "didn't save"
    end

    respond_to do |format|
      format.html { redirect_to song_path(@song) }
      format.json { render :json => @song.to_json }
    end
  end

  def new
    
  end

  def edit

  end

  def show
    @song = Song.find params[:id]

    respond_to do |format|
      format.html
      format.json { render :json => @song.to_json }
    end
  end

  def update

  end

  def destroy

  end
end
