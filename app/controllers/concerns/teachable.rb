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
    @teachable = model_class.find(params[:id])

    render :template => "shared/quiz"
  end

  def save_teachable(teachable)
    changes = [teachable]
    changes += save_cards(teachable.flash_cards, cards_params[:cards])

    changes.each &:save!
  end

  def get_difficulties
    @flash_card_ids = model_class.find(params[:id]).flash_cards.collect &:id

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

  def changeset(existing_models, model_params, debug=false)
    model_params = model_params || []

    added    = model_params.select { |m| m[:id].empty? }
    modified = model_params.reject { |m| m[:id].empty? }
    deleted  = existing_models.map(&:id) - modified.map { |m| m[:id].to_i }

    return { :added => added, :modified => modified, :deleted => deleted }
  end

  def find_model(clazz, id)
    model = clazz.find_by_id(id)

    return model if @user.owns? model
  end

  def save_cards(existing_cards, card_params)
    changes = changeset(existing_cards, card_params)
    changed = Array.new

    changes[:added].each do |card_param|
      card = FlashCard.new card_param.except(:examples)
      existing_cards << card

      changed << card
      changed += save_examples(card.examples, card_param[:examples])
    end

    changes[:deleted].each do |id|
      card = find_model(FlashCard, id)

      next if card.nil?

      difficulties = Difficulty.where("flash_card_id = ?", id)

      difficulties.each &:delete
      card.examples.each &:delete
      card.delete
    end

    changes[:modified].each do |card_param|
      card = find_model(FlashCard, card_param[:id])

      next if card.nil?

      card.update card_param.except(:examples)
      changed << card
      changed += save_examples(card.examples, card_param[:examples])
    end

    return changed
  end

  def save_examples(existing_examples, example_params)
    changes = changeset(existing_examples, example_params, true)
    changed = Array.new

    changes[:added].each do |example_param|
      example = Example.new example_param
      existing_examples << example
      changed << example
    end

    changes[:deleted].each do |id|
      example = find_model(Example, id)

      next if example.nil?

      example.delete
    end

    changes[:modified].each do |example_param|
      example = find_model(Example, example_param[:id])

      return if example.nil?

      example.update example_param
      changed << example
    end

    return changed
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
