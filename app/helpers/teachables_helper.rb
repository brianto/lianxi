module TeachablesHelper
  def render_characters(flash_cards)
    render :partial => "partials/characters", :locals => {
      :flash_cards => flash_cards
    }
  end

  def render_actions(teachable)
    render :partial => "partials/actions", :locals => {
      :teachable => teachable
    }
  end
end
