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
  end

  module ClassMethods
    def make_filename(extension)
      "/tmp/#{table_name}_#{Time.now.utc.strftime("%Y%m%d%H%M%S")}#{User.current_user.id}.#{extension}"
    end

    def configure
      @config ||= Configure.new
    end

    def resource_exportable_configure
      yield configure
    end

    def export_pdf
      filename = make_filename(:pdf)
      columns = column_names - configure.except_column - EXCEPT
      localized_columns = columns.map{|column| human_attribute_name(column)}

      Prawn::Document.generate(filename) do |pdf|
        pdf.font "/System/Library/Fonts/AppleGothic.ttf"
        pdf.text model_name.human

        pdf.font_size 7
        records = all.map do |resource|
                    columns.map do |column|
                      record = resource.send(column)
                      record = record.strftime("%Y-%m-%d(%H:%m:%S)") if record.respond_to?(:strftime)
                      record
                    end
                  end

        table_data = [localized_columns] + records
        pdf.table table_data, header: true, row_colors: ["F0F0F0", "FFFFCC"] do |table|
          table.row(0).style(:background_color => 'dddddd', :size => 9)
        end
      end

      filename
    end

    def export_xls
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet :name => 'Sheet1'

      columns = column_names - configure.except_column - EXCEPT

      columns.each_with_index do |column, index|
        sheet.row(0).insert index, human_attribute_name(column)
      end

      current_row = 0
      find_each do |transaction|
        current_row = current_row + 1
        columns.each_with_index do |column, index|
          record = transaction.send(column)
          record = record.strftime("%Y-%m-%d(%H:%m:%S)") if record.respond_to?(:strftime)

          sheet.row(current_row).insert index, record
        end
      end

      filename = make_filename(:xls)
      book.write filename
      filename
    end

    def export(extension)
      case extension
      when :xls
        export_xls
      when :pdf
        export_pdf
      end
    end
  end
end