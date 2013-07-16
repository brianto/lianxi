module Type
  include Kernel

  def lesson_of(params)
    clazz = params.keys.select do |key|
      key =~ /(drill|passage|song)_id/
    end.first.capitalize.gsub(/_id/, "")

    Kernel.const_get(clazz)
  end
end
