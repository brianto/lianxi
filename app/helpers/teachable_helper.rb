module TeachableHelper
  # Paths
  def grid_teachable_path(teachable)
    # TODO figure out less icky way
    eval("grid_#{@model_class.to_s.downcase}_path(teachable, :charset => @charset, :transcript => @transcript)")
  end

  # Renderers
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
