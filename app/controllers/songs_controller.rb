class SongsController < ApplicationController
  before_action :require_login, :only => [:new, :create, :edit, :update, :destroy]

  include Teachable

  def index
    @songs = Song.find :all
  end

  def create
    @song = Song.new song_params
    @song.simplified = song_params[:simplified].gsub /\r/, ''
    @song.traditional = song_params[:traditional].gsub /\r/, ''
    @song.translation = song_params[:translation].gsub /\r/, ''
    @song.user = @user

    begin
      create_teachable @song
      redirect_to song_path(@song)
    rescue Exception => e
      render :action => "new"
    end
  end

  def new
    @song = Song.new
  end

  def edit
    @song = Song.find params[:id]

    redirect_to root_path unless @song.user.eql? @user
  end

  def show
    @song = Song.find params[:id]

    respond_to do |format|
      format.html
      format.json do
        render :json => {
          :song => @song,
          :cards => @song.flash_cards.as_json(:include => :examples)
        }.to_json
      end
    end
  end

  def update
    @song = Song.find params[:id]

    @song.update song_params

    begin
      update_teachable @song
      redirect_to song_path(@song)
    rescue Exception => e
      render :action => "edit"
    end
  end

  def destroy

  end

  private

  def song_params
    params.
      require(:song).
      permit(:id, :title, :artist, :youtubeId, :dialect,
             :simplified, :traditional, :translation, :timing => [])
  end
end
