class FlashCardsController < ApplicationController
  include Type

  before_filter :determine_teachables

  def index # GET /[teachable]/:teachable_id/flash_cards
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

  def determine_teachables
    @clazz = lesson_of params
    @clazz_string = @clazz.to_s.downcase
    @teachable = @clazz.find params["#{@clazz_string}_id"]
  end
end
