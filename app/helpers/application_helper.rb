module ApplicationHelper
  def teachable_path(teachable)
    clazz = teachable.class.to_s.downcase
    return eval("#{clazz}_path(teachable)")
  end
end
