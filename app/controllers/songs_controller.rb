class SongsController < TeachablesController
  before_filter :setup_teachables
  before_filter :require_login, :only => [:new, :create, :edit, :update, :destroy]

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

    @examples = Array.new
    # TODO refactor into concern
    @flash_cards = !cards_params[:cards] ? [] : cards_params[:cards].collect do |card_param|
      fc = FlashCard.new do |fc|
        fc.simplified = card_param[:simplified]
        fc.traditional = card_param[:traditional]
        fc.pinyin = card_param[:pinyin]
        fc.jyutping = card_param[:jyutping]
        fc.part_of_speech = card_param[:part_of_speech]
        fc.meaning = card_param[:meaning]
      end

      @song.flash_cards << fc

      @examples += !cards_params[:examples] ? [] : card_param[:examples].collect do |example_param|
        ex = Example.new do |ex|
          ex.simplified = example_param[:simplified]
          ex.traditional = example_param[:traditional]
          ex.translation = example_param[:translation]
        end

        fc.examples << ex
        ex
      end

      fc
    end

    Song.transaction do
      begin
        @song.save!
        @flash_cards.each &:save!
        @examples.each &:save!
      rescue Exception => e
        render :action => "new"
      end
    end

    redirect_to song_path(@song)
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

  # TODO refactor into concern
  def cards_params
    params.permit :cards => [
      :simplified, :traditional, :pinyin, :jyutping, :part_of_speech, :meaning, :id, :examples => [
        :simplified, :traditional, :translation, :id ]]
  end
end
