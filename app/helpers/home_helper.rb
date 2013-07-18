module HomeHelper
  def render_teachables(title, teachables)
    render :partial => "teachables", :locals => {
      :title => title.to_s,
      :lessons => teachables.to_a
    }
  end
end
