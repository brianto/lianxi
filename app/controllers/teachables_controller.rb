class TeachablesController < ApplicationController
  before_filter :require_login, :only => [:update_difficulties]

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

  def difficulty_update_params
    params.permit :id, :user_id, :flash_card_id, :difficulty
  end
end
