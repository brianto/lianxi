class FlashCardsController < ApplicationController
  def index # GET /[teachable]/:teachable_id/flash_cards
    @teachable = teachable
    @cards = @teachable.flash_cards

    respond_to do |format|
      format.html
      format.json { render :json => @cards.to_json }
    end
  end

  def create # POST /[teachable]/:teachable_id/flash_card
    @teachable = teachable
    @card = FlashCard.new params[:flash_card]
    @card.teachable = @teachable

    respond_to do |format|
      if @card.save
        format.html { redirect_to [@teachable], :notice => "Flash Card was successfully created" }
        format.json { render :json => @card.to_json, :status => :created, :location => [@teachable, @card] }
      else
        @errors = @card.errors.messages

        format.html { render :action => "new" }
        format.json { render :json => @card.errors, :status => :unprocessable_entity }
      end
    end
  end

  def new
    @teachable = teachable
    @card = FlashCard.new :teachable_id => @teachable.id,
      :teachable_type => @teachable.class.to_s.underscore

    @errors = Hash.new
  end

  def edit

  end

  def show # GET /[teachable]/:teachable_id/flashcards/:id
    @card = FlashCard.find params[:id]
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
