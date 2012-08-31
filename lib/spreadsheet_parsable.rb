module SpreadsheetParsable
  extend ActiveSupport::Concern

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

    def excel_parser(type)
      parser_name = "#{type}_#{self.to_s.tableize.singularize}_parser"
      send(parser_name)
    rescue NoMethodError
      raise "Cannot find excel parser. parser_name = #{parser_name}"
    end
  end

  included do
    extend ClassMethods
  end
end