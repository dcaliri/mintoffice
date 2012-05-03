class NewExcelParser
  def class_name(class_name)
    @class_name = class_name
  end
  def column(columns)
    @columns = columns
  end

  def key(keys)
    @keys = keys
  end

  def option(opts)
    @options = {position: {:start => {x: 2, y: 1}, :end => 0}}.merge(opts)
  end

  def preview(file)
    previews = []
    parse(file) {|class_name, query, params| previews << class_name.new(params)}
    previews
  end

  def parse(file)
    parser = Excel
    parser = Excelx if(file.last == 'x')

    position = @options[:position]

    sheet = parser.new(file)
    position[:start][:x].upto(sheet.last_row + position[:end]) do |i|
      params = {}
      @columns.each_with_index do |column, j|
        params[column] = sheet.cell(i, j + position[:start][:y])
      end

      query = {}
      @keys.each do |key, value|
        if value == :time
          query[key] = Time.zone.parse(params[key])
        else
          query[key] = params[key]
        end
      end

      yield @class_name, query, params
    end
  end
end