class DrillsController < TeachablesController
  before_filter :setup_teachables
  before_filter :require_login, :only => [:new, :create, :edit, :update, :destroy]

  include Teachable

  def setup_teachables
    @model_class = Drill
  end

  def index
    @drills = Drill.find(:all)
  end

  def create
    @drill = Drill.new drill_params
    @drill.user = @user

    begin
      save_teachable @drill
      redirect_to drill_path(@drill)
    rescue Exception => e
      render :action => "new"
    end
  end

  def new
    @drill = Drill.new
  end

  def edit
    @drill = Drill.find params[:id]

    redirect_to root_path unless @drill.user.eql? @user
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

    @drill.update drill_params

    @cards = cards_params[:cards]
    @delta = {
      :added => Array.new,
      :modified => Array.new,
      :deleted => Array.new
    }

    # TODO refactor save added/modified/deleted for handling examples as well
    @cards.each do |card|
      if card[:id].eql? '' # new card
        @card = FlashCard.new card
        @card.teachable = @drill
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

    idsBeforeSave = @drill.flash_cards.collect do |card|
      card.id
    end

    deletedCardIds = idsBeforeSave - idsAfterSave
    @delta[:deleted] = FlashCard.find deletedCardIds

    Drill.transaction do
      begin
        @drill.save!
        @delta[:added].each &:save!
        @delta[:modified].each &:save!
        @delta[:deleted].each &:destroy!

        redirect_to drill_path(@drill)
      rescue
        render :action => "edit"
      end
    end
  end

  def destroy

  end

  private

  def drill_params
    params.require(:drill).permit(:title, :description)
  end
end
