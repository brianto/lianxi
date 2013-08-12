class ExamplesController < ApplicationController
  def index
    @card = FlashCard.find params[:flash_card_id]
    @teachable = @card.teachable
    @examples = @card.examples
  end

  def create
    @example = Example.new params[:example]
    @teachable = teachable
    @example.flash_card_id = params[:flash_card_id]
    @card = @example.flash_card

    respond_to do |format|
      if @example.save
        format.html { redirect_to [@teachable, @card, @example], :notice => "Example was successfully created" }
        format.json { render :json => @example.to_json, :status => :created, :location => [@teachable, @card, @example] }
      else
        @errors = @example.errors.messages

        format.html { render :action => "new" }
        format.json { render :json => @example.errors, :status => :unprocessable_entity }
      end
    end
  end

  def new
    @card = FlashCard.find params[:flash_card_id]
    @example = Example.new :flash_card_id => @card.id
    @teachable = teachable

    @errors = Hash.new
  end

  def edit

  end

  def show
    @example = Example.find params[:id]
  end

  def update

  end

  def destroy

  end

  private

  def teachable
    params.each do |name, value|
      if name =~ /(.+)_id$/ then
        return $1.classify.constantize.find(value)
      end
    end
  end
end
