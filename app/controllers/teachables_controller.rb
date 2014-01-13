class TeachablesController < ApplicationController
  def grid
    flash_cards = @model_class.find(params[:id]).flash_cards

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
end
