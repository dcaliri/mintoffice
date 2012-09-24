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

    def no_header
      opts[:header] = false
    end

    def align(direction, key)
      opts[:align][direction] = key
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
        krw: [],
        header: true,
        align: {
          left: [],
          right: []
        }
      }
    end
  end

  module ClassMethods
    def make_filename(extension)
      default_folder = "/tmp"
      File.directory?(default_folder) || Dir.mkdir(default_folder)

      "#{Rails.root}/tmp/#{table_name}_#{Time.now.utc.strftime("%Y%m%d%H%M%S")}#{Person.current_person.id}.#{extension}"
      # "#{Rails.root}/tmp/#{table_name}.#{extension}"
    end

    def configure
      @config ||= Configure.new
    end

    def resource_exportable_configure
      yield configure
    end

    def export(extension, include_columns = nil)
      columns = include_columns ? include_columns.keys.map(&:to_sym) : default_columns
      filename = make_filename(extension)

      case extension
      when :xls
        ExcelExporter.new(self, filename, columns, configure.opts).export
      when :pdf
        PdfExporter.new(self, filename, columns, configure.opts).export
      end
    end
  end
end