# encoding: UTF-8

module PdfExportable
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
    def configure
      @config ||= Configure.new
    end

    def pdf_exportable_configure
      yield configure
    end

    def export_pdf
      filename = "/tmp/#{table_name}_#{Time.now.utc.strftime("%Y%m%d%H%M%S")}#{User.current_user.id}.pdf"
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
  end

  included do
    extend ClassMethods
  end
end