module TeachableHelper
  def render_characters(flash_cards)
    render :partial => "partials/characters", :locals => {
      :flash_cards => flash_cards
    }
  end
end
