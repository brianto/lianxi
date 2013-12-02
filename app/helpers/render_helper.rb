module RenderHelper
  def render_field(form, errors, key, field, options)
    render :partial => "partials/form_field", :locals => {
      :form => form,
      :errors => errors,
      :key => key,
      :field => field,
      :options => options
    }
  end

  def render_teachables(type, teachables)
    render :partial => "teachables", :locals => {
      :type => type,
      :lessons => teachables
    }
  end

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

  def render_lyrics(song)
    render :partial => "lyrics", :locals => {
      :song => song
    }
  end
end
