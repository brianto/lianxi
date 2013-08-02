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

  end

  def new

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
