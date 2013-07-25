class TeachablesController < ApplicationController
  before_filter :model_class
  before_filter :preferences

  def explode_flash_cards(cards)
    return cards.collect do |word|
      characters = word.send(@charset).each_char.to_a
      pronounciation = word.send(@transcript).split(/\s/)

      characters = characters.zip(pronounciation).collect do |entry|
        hanzi, pro = entry

        { :hanzi => hanzi, :pronounciation => pro }
      end

      { :meaning => word.meaning, :characters => characters }
    end
  end

  private

  def model_class
    return unless @model_class.nil?

    @model_class = Kernel.const_get self.class.to_s.gsub(/sController/, "")
  end

  def preferences
    @charset = params[:charset] || cookies[:charset] || :traditional
    @transcript = params[:transcript] || cookies[:transcript] || :pinyin
  end
end
