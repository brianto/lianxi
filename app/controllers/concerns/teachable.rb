module Teachable
  extend ActiveSupport::Concern

  included do
    before_action :require_login, :only => :update_difficulties
  end

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

  def create_teachable(teachable)
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

    model_class.transaction do
      teachable.save!
      cards.each &:save!
      examples.each &:save!
    end
  end

  def update_teachable(teachable)
    raw_cards = cards_params[:cards]

    delta = {
      :added => Array.new,
      :modified => Array.new,
      :deleted => Array.new
    }

    raw_cards.each do |card_param|
      # TODO save examples as well
      if card_param[:examples]
        card_param.delete :examples
      end

      if card_param[:id].eql? '' # new card
        card = FlashCard.new card_param
        card.teachable = teachable
        delta[:added] << card
      else # existing card
        card = FlashCard.find card_param[:id]
        card.update card_param
        delta[:modified] << card
      end
    end

    idsAfterSave = raw_cards.inject(Array.new) do |result, card|
      result << card[:id].to_i unless card[:id].eql? ''
      result
    end

    idsBeforeSave = teachable.flash_cards.collect do |card|
      card.id
    end

    deletedCardIds = idsBeforeSave - idsAfterSave
    delta[:deleted] = FlashCard.find deletedCardIds

    model_class.transaction do
      teachable.save!
      delta[:added].each &:save!
      delta[:modified].each &:save!
      delta[:deleted].each &:destroy!
    end
  end

  def get_difficulties
    @flash_card_ids = @model_class.find(params[:id]).flash_cards.collect &:id

    respond_to do |format|
      format.json do
        if @user
          records = Difficulty.where(
            "user_id = ? AND flash_card_id IN (?)", @user, @flash_card_ids)

          render :json => records
        else
          render :json => []
        end
      end
    end
  end

  def update_difficulties
    if @user.nil?
      return render :nothing => true
    end

    user_id = difficulty_update_params[:user_id]
    fc_id = difficulty_update_params[:flash_card_id]
    difficulty = difficulty_update_params[:difficulty]

    @difficulty = Difficulty.where(
      "user_id = ? AND flash_card_id = ?", user_id, fc_id).first

    if @difficulty
      @difficulty.difficulty = difficulty
    else
      @difficulty = Difficulty.new :user => @user,
        :flash_card_id => fc_id,
        :difficulty => difficulty
    end

    @difficulty.save!

    render :nothing => true
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

  def difficulty_update_params
    params.permit :id, :user_id, :flash_card_id, :difficulty
  end
end
