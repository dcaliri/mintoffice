require 'iconv'

module StylesheetParseable
  extend ActiveSupport::Concern

  class ExcelParser
    def column(columns)
      @columns = columns
    end

    def parse(file)
      sheet = Excel.new(file)

      2.upto(sheet.last_row) do |i|
        params = {}
        @columns.each_with_index do |column, j|
          params[column] = sheet.cell(i, j+1)
        end
        yield params
      end
    end
  end

  module ClassMethods
    def set_parser_columns(*columns)
      @excel_columns = *columns
    end

    def open_and_parse_stylesheet(upload)
      name = upload['file'].original_filename
      directory = "tmp"
      path = File.join(directory, name)
      File.open(path, "wb") { |f| f.write(upload['file'].read) }
      parse_stylesheet(path)
      File.delete(path)
    end

    def parse_stylesheet(file)
      parser = ExcelParser.new
      parser.column @excel_columns

      parser.parse(file) do |params|
        collections = where(make_unique_key(params))
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