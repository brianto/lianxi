module ApplicationHelper
  def render_field(form, errors, key, field, options)
    render :partial => "partials/form_field", :locals => {
      :form => form,
      :errors => errors,
      :key => key,
      :field => field,
      :options => options
    }
  end
end
