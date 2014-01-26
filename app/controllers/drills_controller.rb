class DrillsController < ApplicationController
  before_action :require_login, :only => [:new, :create, :edit, :update, :destroy]

  include Teachable

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
      raise e.to_s
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

    begin
      save_teachable @drill
      redirect_to drill_path(@drill)
    rescue Exception => e
      raise e.to_s
      render :action => "edit"
    end
  end

  def destroy

  end

  private

  def drill_params
    params.require(:drill).permit(:title, :description)
  end
end
