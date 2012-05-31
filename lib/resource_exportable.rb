module ResourceExportable
  extend ActiveSupport::Concern
  EXCEPT = ["id", "created_at", "updated_at"]

  class Configure
    def except_column(column=nil)
      @except_columns = @except_columns || []
      @except_columns.tap do |columns|
        columns << column if column
      end
    end

    def include_column(column=nil)
      @include_columns = @include_columns || []
      @include_columns.tap do |columns|
        columns << column if column
      end
    end
  end

  module ClassMethods
    def make_filename(extension)
      # "#{Rails.root}/tmp/#{table_name}_#{Time.now.utc.strftime("%Y%m%d%H%M%S")}#{User.current_user.id}.#{extension}"
      "#{Rails.root}/tmp/#{table_name}.#{extension}"
    end

    def configure
      @config ||= Configure.new
    end

    def resource_exportable_configure
      yield configure
    end

    def export(extension)
      columns = configure.include_column + column_names - configure.except_column - EXCEPT
      filename = make_filename(extension)

      case extension
      when :xls
        ExcelExporter.new(self, filename: filename, columns: columns).export
      when :pdf
        PdfExporter.new(self, filename: filename, columns: columns).export
      end
    end
  end
end