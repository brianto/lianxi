class TeachablesController < ApplicationController
  def grid
    cards = @model_class.find(params[:id]).flash_cards

    @words = cards.collect do |word|
      characters = word.send(@charset).each_char.to_a
      pronounciation = word.send(@transcript).split(/\s/)

      characters = characters.zip(pronounciation).collect do |entry|
        hanzi, pro = entry

        { :hanzi => hanzi, :pronounciation => pro }
      end

      { :meaning => word.meaning, :characters => characters }
    end

    render :layout => "bare", :template => "shared/grid"
  end

  def quiz
    @teachable = @model_class.find(params[:id])

    render :template => "shared/quiz"
  end
end
