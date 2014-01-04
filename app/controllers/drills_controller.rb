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
    @drill = Drill.new params[:drill]

    if @drill.save
      redirect_to @drill, :notice => "Drill was successfully created"
    else
      @errors = @drill.errors.messages
      render :action => "new"
    end
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
        render :json => @drill.to_json(:include => :flash_cards)
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
end
