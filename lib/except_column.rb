module ExceptColumn
  def set_model_name(name)
    @model_name = name
  end

  def model_name
    @model_name
  end

  def set_num_rows(rows)
    @num_rows = rows
  end

  def numrow?(column)
    @num_rows.include?(column)
  end

  def except?(column)
    controller.except_column?(model_name, column.to_sym)
  end

  # TODO: html safe
  def th_column(column)
    unless except? column
      "<th>#{model_name.to_s.classify.constantize.human_attribute_name(column)}</th>"
    else
      ""
    end
  end

  # TODO: html safe
  def td_column(model, column, value = nil)
    value = value || model.send(column)
    if numrow? column
      class_option = " class='numrow'"
      value = number_to_currency(value)
    end

    unless except? column
      "<td#{class_option}>#{value}</td>"
    else
      ""
    end
  end

  def on_click_path(resource)
    href = send(model_name.to_s + '_path', resource)
    resource.new_record? ? "" : "location.href='#{href}'"
  end
end