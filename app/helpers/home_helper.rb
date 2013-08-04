module HomeHelper
  def render_teachables(type, teachables)
    render :partial => "teachables", :locals => {
      :title => type.to_s.humanize,
      :lessons => teachables
    }
  end
end
