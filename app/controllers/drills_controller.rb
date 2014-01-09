class DrillsController < TeachablesController
  before_filter :setup_teachables
  before_filter :require_login, :only => [:new, :create, :edit, :update, :destroy]

  def setup_teachables
    @model_class = Drill
  end

  def index
    @drills = Drill.find(:all)
  end

  def create
    @drill = Drill.new drill_params
    @drill.user = @user

    @flash_cards = cards_params[:cards].collect do |card_param|
      FlashCard.new card_param
    end

    Drill.transaction do
      begin
        @drill.save!
        @flash_cards.each &:save!

        @drill.flash_cards = @flash_cards
        @drill.save!
      rescue Exception => e
        @errors = @drill.errors.messages
        render :action => "new"
      end
    end

    redirect_to drill_path(@drill)
  end

  def new
    @drill = Drill.new
    @errors = Hash.new
  end

  def edit
    @drill = Drill.find params[:id]
    @errors = Hash.new
    @debug = self
  end

  def show
    @drill = Drill.find params[:id]

    respond_to do |format|
      format.html
      format.json do
        data = { :drill => @drill, :cards => @drill.flash_cards.as_json(:include => :examples) }
        render :json => data.to_json
      end
    end
  end

  def update
    @drill = Drill.find params[:id]

    updates = params[:drill]

    @drill.title = updates[:title]
    @drill.description = updates[:description]

    if @drill.save then
      redirect_to drill_path(@drill)
    else
      @errors = @drill.errors.messages
      render :action => "edit"
    end
  end

  def destroy

  end

  private

  def drill_params
    params.require(:drill).permit(:title, :description)
  end

  def cards_params
    params.permit :cards => [
      :simplified, :traditional, :pinyin, :jyutping, :part_of_speech, :meaning, :id, :examples => [
        :simplified, :traditional, :pinyin, :jyutping, :translation, :id ]]
  end
end
