class DrillsController < ApplicationController
  def grid # GET (grid_drill)
    cards = Drill.find(params[:id]).flash_cards
    charset = params[:charset] || cookies[:charset] || :traditional
    transcript = params[:transcript] || cookies[:transcript] || :pinyin

    @words = cards.collect do |word|
      characters = word.send(charset).each_char.to_a
      pronounciation = word.send(transcript).split(/\s/)

      characters = characters.zip(pronounciation).collect do |entry|
        hanzi, pro = entry

        { :hanzi => hanzi, :pronounciation => pro }
      end

      { :meaning => word.meaning, :characters => characters }
    end

    render :layout => "bare", :template => "shared/grid"
  end

  def index # GET /drills (drills)
    @drills = Drill.find(:all)

    respond_to do |format|
      format.html
      format.json { render :json => @drills.to_json }
    end
  end

  def create # POST /drills
    @drill = Drill.create params[:drill]

    respond_to do |format|
      format.html { redirect_to drill_path(@drill) }
      format.json { render :json => @drill.to_json }
    end
  end

  def new # GET /drills/new (new_drill) [html only]

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
