module ExceptColumnView
  def draw_table(collection)
    html_code = ""
    html_code += "<table id='list-table'>"
    html_code += "<tr>"

    columns.each do |column|
      html_code += th_column(column)
    end

    html_code += "</tr>"

    collection.each do |resource|
      html_code += "<tr class='selectable', #{on_click_path(resource)}>"
      columns.each do |column|
        html_code += td_column(resource, column)
      end
      html_code += "</tr>"
    end

    html_code += "</table>"
    html_code
  end

  def set_model_name(name)
    @model_name = name
  end

  def model_name
    @model_name
  end

  def set_num_rows(rows)
    @num_rows = rows
  end

  def set_columns(columns)
    @columns = columns
  end

  def columns
    @columns
  end

  def numrow?(column)
    @num_rows.include?(column)
  end

  def except?(column)
    columns = current_employee.except_columns.where(model_name: model_name.to_s.classify).default
    unless columns.empty?
      !columns.first.columns[column.to_s]
    else
      false
    end
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
    resource.new_record? ? "" : " onclick = location.href='#{send(model_name.to_s + '_path', resource)}'"
  end
end