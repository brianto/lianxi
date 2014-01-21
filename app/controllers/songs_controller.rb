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

      @examples += card_param[:examples].collect do |example_param|
        ex = Example.new do |ex|
          ex.simplified = example_param[:simplified]
          ex.traditional = example_param[:traditional]
          ex.pinyin = example_param[:pinyin]
          ex.jyutping = example_param[:jyutping]
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

  private

  def song_params
    params.
      require(:song).
      permit(:id, :title, :artist, :youtubeId, :dialect,
             :simplified, :traditional, :timing => [])
  end

  # TODO refactor into concern
  def cards_params
    params.permit :cards => [
      :simplified, :traditional, :pinyin, :jyutping, :part_of_speech, :meaning, :id, :examples => [
        :simplified, :traditional, :pinyin, :jyutping, :translation, :id ]]
  end
end
