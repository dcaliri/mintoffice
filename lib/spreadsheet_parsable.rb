module SpreadsheetParsable
  extend ActiveSupport::Concern

  module ClassMethods
    def file_path(name)
      directory = "tmp"
      File.join(directory, name)
    end

    def excel_parser(type)
      parser_name = "#{type}_#{self.to_s.tableize.singularize}_parser"
      send(parser_name)
    rescue NoMethodError
      raise "Cannot find excel parser. parser_name = #{parser_name}"
    end

    def preview_stylesheet(type, upload)
      raise ArgumentError, I18n.t('common.upload.empty') unless upload
      path = file_path(upload['file'].original_filename)
      File.open(path, "wb") { |f| f.write(upload['file'].read) }

      preview = []
      parser = excel_parser(type.to_sym)
      parser.parse(path) do |class_name, query, params|
        preview << yield(class_name, query, params)
      end
      preview
    end

    def create_with_stylesheet(type, name)
      path = file_path(name)
      parser = excel_parser(type.to_sym)

      transaction do
        parser.parse(path) do |class_name, query, params|
          yield class_name, query, params
        end
      end

      File.delete(path)
    end
  end

  included do
    extend ClassMethods
  end
end