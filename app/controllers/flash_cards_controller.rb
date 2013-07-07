class FlashCardsController < ApplicationController
  include Type

  def index
    clazz = lesson_of params
    @clazz_string = clazz.to_s.downcase

    @teachable = clazz.find params["#{@clazz_string}_id"]
    @cards = @teachable.flash_cards

    respond_to do |format|
      format.html
      format.json { render :json => @cards.to_json }
    end
  end

  def create

  end

  def new

  end

  def edit

  end

  def show
    @card = FlashCard.find params[:id]
  end

  def update

  end

  def destroy

  end
end
