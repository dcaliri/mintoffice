require 'iconv'

module StylesheetParseable
  extend ActiveSupport::Concern

  class ExcelParser
    def column(columns)
      @columns = columns
    end

    def option(opts)
      @options = {position: {:start => {x: 2, y: 1}, :end => 0}}.merge(opts)
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
        yield params
      end
    end
  end

  module ClassMethods
    def set_parser_options(opts)
      @excel_columns ||= {}
      @excel_keys ||= {}
      @excel_options ||= {}

      type = opts[:name]
      @excel_columns[type] = opts[:columns]
      @excel_keys[type] = opts[:keys]
      @excel_options[type] = {position: opts[:position]}
    end

    def open_and_parse_stylesheet(upload, type = :default)
      name = upload['file'].original_filename
      directory = "tmp"
      path = File.join(directory, name)
      File.open(path, "wb") { |f| f.write(upload['file'].read) }
      parse_stylesheet(path, type.to_sym)
      File.delete(path)
    end

    def parse_stylesheet(file, type = :default)
      parser = ExcelParser.new
      parser.column @excel_columns[type]
      parser.option @excel_options[type]

      parser.parse(file) do |params|
        if respond_to?(:before_parser_filter) && before_parser_filter(params) == false
          next
        end

        query = {}
        @excel_keys[type].each do |key, value|
          if value == :time
            query[key] = Time.zone.parse(params[key])
          else
            query[key] = params[key]
          end
        end

        collections = where(query)
        if collections.empty?
          create!(params)
        else
          resource = collections.first
          resource.update_attributes!(params)
        end
      end
    end
  end

  included do
    extend ClassMethods
  end
end