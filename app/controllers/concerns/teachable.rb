module Teachable
  extend ActiveSupport::Concern

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

  def cards_params
    params.permit :cards => [
      :simplified, :traditional,
      :pinyin, :jyutping,
      :part_of_speech, :meaning, :id, :examples => [
        :simplified, :traditional, :translation, :id ]]
  end
end
