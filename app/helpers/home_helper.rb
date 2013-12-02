module HomeHelper
  def render_teachables(type, teachables)
    render :partial => "teachables", :locals => {
      :type => type,
      :lessons => teachables
    }
  end
end
