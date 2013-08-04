class DrillsController < TeachablesController
  before_filter :setup_teachables

  def setup_teachables
    @model_class = Drill
  end

  def index # GET /drills (drills)
    @drills = Drill.find(:all)

    respond_to do |format|
      format.html
      format.json { render :json => @drills.to_json }
    end
  end

  def create # POST /drills
    @drill = Drill.new params[:drill]

    respond_to do |format|
      if @drill.save
        format.html { redirect_to @drill, :notice => "Drill was successfully created" }
        format.json { render :json => @drill.to_json, :status => :created, :location => @drill }
      else
        @errors = @drill.errors.messages

        format.html { render :action => "new" }
        format.json { render :json => @drill.errors, :status => :unprocessable_entity }
      end
    end
  end

  def new # GET /drills/new (new_drill) [html only]
    @drill = Drill.new
    @errors = Hash.new
  end

  def edit # GET /drills/:id/edit (edit_drill) [html only]
    @drill = Drill.find params[:id]
  end

  def show # GET /drills/:id (drill)
    @drill = Drill.find params[:id]

    respond_to do |format|
      format.html
      format.json { render :json => @drill.to_json }
    end
  end

  def update # PUT /drills/:id
    @drill = Drill.find params[:id]

    updates = params[:drill]

    @drill.title = updates[:title]
    @drill.description = updates[:description]

    if @drill.save then
      respond_to do |format|
        format.html { redirect_to drill_path(@drill) }
        format.json { render :json => @drill.to_json }
      end
    end
  end

  def destroy # DELETE /drills/:id

  end
end
