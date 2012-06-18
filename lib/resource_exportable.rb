module ResourceExportable
  extend ActiveSupport::Concern
  EXCEPT = [:id, :created_at, :updated_at]

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

    def pdf_page_layout(type)
      opts[:layout_type] = type
    end
    def krw(to)
      opts[:krw] = to
    end

    def subtitle(text)
      opts[:subtitle] = text
    end

    def period_subtitle(column)
      opts[:period] = column
    end

    def opts
      @opts ||= {
        subtitle: "",
        layout_type: :landscape,
        krw: []
      }
    end
  end

  module ClassMethods
    def make_filename(extension)
      "#{Rails.root}/tmp/#{table_name}_#{Time.now.utc.strftime("%Y%m%d%H%M%S")}#{User.current_user.id}.#{extension}"
      # "#{Rails.root}/tmp/#{table_name}.#{extension}"
    end

    def configure
      @config ||= Configure.new
    end

    def resource_exportable_configure
      yield configure
    end

    def export(extension, except_columns = nil)
      unless except_columns
        columns = configure.include_column + column_names.map(&:to_sym) - configure.except_column - EXCEPT
      else
        columns = default_columns - except_columns
      end

      filename = make_filename(extension)

      case extension
      when :xls
        # ExcelExporter.new(self, filename: filename, columns: columns, krw: configure.opts[:krw]).export
        ExcelExporter.new(self, filename, columns, configure.opts).export
      when :pdf
        PdfExporter.new(self, filename, columns, configure.opts).export
      end
    end
  end
end