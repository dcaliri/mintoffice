require 'iconv'

class ExcelParser
  def class_name(class_name)
    @class_name = class_name
  end

  def column(columns)
    @columns = columns
  end

  def column_keys
    @columns.keys
  end

  def column_names
    @columns.values
  end

  def key(keys)
    @keys = keys
  end

  def option(opts)
    @options = {position: {:start => {x: 2, y: 1}, :end => 0}, validate: true}.merge(opts)
  end

  def preview(file)
    previews = []
    parse(file) do |class_name, query, params|
      previews << class_name.new(params)
    end
    previews
  end

  def valid?(sheet)
    return true unless @options[:validate]
    position = @options[:position]
    column_keys.each_with_index do |column, i|
      column_name = sheet.cell(position[:start][:x] - 1, i + position[:start][:y])
      return false if column_name != column_names[i]
    end
    true
  end

  def parse(file)
    parser = Excel
    parser = Excelx if(file.last == 'x')

    position = @options[:position]

    sheet = parser.new(file)
    raise ArgumentError, I18n.t('common.upload.invalid_xls') unless valid?(sheet)

    position[:start][:x].upto(sheet.last_row + position[:end]) do |i|
      params = {}
      column_keys.each_with_index do |column, j|
        value = sheet.cell(i, j + position[:start][:y])
        value.strip! if value.respond_to? :strip!
        params[column] = value
      end

      query = {}
      @keys.each do |key, value|
        if value == :time
          query[key] = Time.parse(params[key])
        else
          query[key] = params[key]
        end
      end

      yield @class_name, query, params
    end
  end
end