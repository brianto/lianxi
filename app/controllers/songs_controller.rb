class SongsController < TeachablesController
  before_filter :setup_teachables
  before_filter :require_login, :only => [:new, :create, :edit, :update, :destroy]

  include Teachable

  def setup_teachables
    @model_class = Song
  end

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
      save_teachable @song
      redirect_to drill_path(@song)
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

    @cards = cards_params[:cards] || []
    @delta = {
      :added => Array.new,
      :modified => Array.new,
      :deleted => Array.new
    }

    # TODO refactor save added/modified/deleted for handling examples as well
    @cards.each do |card|
      if card[:id].eql? '' # new card
        @card = FlashCard.new card
        @card.teachable = @song
        @delta[:added] << @card
      else # existing card
        @card = FlashCard.find card[:id]
        @card.update card
        @delta[:modified] << @card
      end
    end

    idsAfterSave = @cards.inject(Array.new) do |result, card|
      result << card[:id].to_i unless card[:id].eql? ''
      result
    end

    idsBeforeSave = @song.flash_cards.collect do |card|
      card.id
    end

    deletedCardIds = idsBeforeSave - idsAfterSave
    @delta[:deleted] = FlashCard.find deletedCardIds

    Song.transaction do
      begin
        @song.save!
        @delta[:added].each &:save!
        @delta[:modified].each &:save!
        @delta[:deleted].each &:destroy!

        redirect_to song_path(@song)
      rescue
        render :action => "edit"
      end
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
