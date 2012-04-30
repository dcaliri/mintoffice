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
    def file_path(name)
      directory = "tmp"
      File.join(directory, name)
    end

    def create_file(path, file)
      File.open(path, "wb") { |f| f.write(file.read) }
    end

    def remove_file(path)
      File.delete(path)
    end

    def open_and_parse_stylesheet(upload, type = :default)
      type = type.to_sym
      path = file_path(upload['file'].original_filename)
      create_file(path, upload['file'])
      parse_stylesheet(path, type.to_sym)
      remove_file(path)
    end

    def preview_stylesheet(upload, type = :default)
      path = file_path(upload['file'].original_filename)
      create_file(path, upload['file'])
      parse_stylesheet(path, type.to_sym, preview: true)
    end

    def create_with_stylesheet(name, type = :default)
      path = file_path(name)
      parse_stylesheet(path, type.to_sym)
      File.delete(path)
    end

    def set_parser_options(opts)
      @excel_columns ||= {}
      @excel_keys ||= {}
      @excel_options ||= {}

      type = opts[:name]
      @excel_columns[type] = opts[:columns]
      @excel_keys[type] = opts[:keys]
      @excel_options[type] = {position: opts[:position]}
    end

    def parse_stylesheet(file, type = :default, opts = {})
      type = type.to_sym
      parser = ExcelParser.new
      parser.column @excel_columns[type]
      parser.option @excel_options[type]

      previews = []
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

        if opts[:preview]
          previews << new(params)
          next
        end

        collections = where(query)
        if collections.empty?
          create!(params)
        else
          resource = collections.first
          resource.update_attributes!(params)
        end
      end

      previews
    end
  end

  included do
    extend ClassMethods
  end
end