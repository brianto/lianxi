module Teachable
  extend ActiveSupport::Concern

  def grid
    flash_cards = model_class.find(params[:id]).flash_cards

    @words = flash_cards.inject(Array.new) do |words, word|
      row_data = {
        :simplified => //,
        :traditional => //,
        :pinyin => /\s+/,
        :jyutping => /\s+/
      }.collect { |key, splitter|
        word[key].split splitter
      }.transpose.collect { |zipchar|
        {
          :simplified => zipchar[0],
          :traditional => zipchar[1],
          :pinyin => zipchar[2],
          :jyutping => zipchar[3],
        }
      }

      words << {
        :meaning => word[:meaning],
        :characters => row_data
      }

      words
    end

    render :layout => "bare", :template => "shared/grid"
  end

  def quiz
    @teachable = @model_class.find(params[:id])

    render :template => "shared/quiz"
  end

  def save_teachable(teachable)
    raw_cards = cards_params[:cards] || []

    examples = Array.new
    cards = raw_cards.collect do |card_param|
      fc = FlashCard.new do |fc|
        fc.simplified = card_param[:simplified]
        fc.traditional = card_param[:traditional]
        fc.pinyin = card_param[:pinyin]
        fc.jyutping = card_param[:jyutping]
        fc.part_of_speech = card_param[:part_of_speech]
        fc.meaning = card_param[:meaning]
      end

      teachable.flash_cards << fc

      raw_examples = card_param[:examples] || []

      examples += raw_examples.collect do |example_param|
        ex = Example.new do |ex|
          ex.simplified = example_param[:simplified]
          ex.traditional = example_param[:traditional]
          ex.translation = example_param[:translation]
        end

        fc.examples << ex
        ex
      end

      fc
    end

    teachable.class.transaction do
      teachable.save!
      cards.each &:save!
      examples.each &:save!
    end
  end

  private

  def model_class
    params[:controller].classify.constantize
  end

  def cards_params
    params.permit :cards => [
      :simplified, :traditional,
      :pinyin, :jyutping,
      :part_of_speech, :meaning, :id, :examples => [
        :simplified, :traditional, :translation, :id ]]
  end
end
