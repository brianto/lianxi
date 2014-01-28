module RenderHelper
  def render_field(form, key, field, options)
    render :partial => "partials/form_field", :locals => {
      :form => form,
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

  def render_teachable_item(header, lessons)
    render :partial => "teachable_item", :locals => {
      :header => header,
      :lessons => lessons
    }
  end

  def render_characters(flash_cards)
    render :partial => "partials/characters", :locals => {
      :flash_cards => flash_cards
    }
  end

  def render_actions(teachable, *actions)
    render :partial => "partials/actions", :locals => {
      :teachable => teachable,
      :actions => actions
    }
  end

  def render_lyrics(song)
    render :partial => "lyrics", :locals => {
      :song => song
    }
  end

  def render_hidden_angular_field(options)
    render :partial => "partials/form_hidden_angular_field", :locals => options
  end
end
