module ResourceExportable
  class ExcelExporter
    include ActionView::Helpers::NumberHelper

    attr_accessor :collections
    attr_accessor :filename
    attr_accessor :columns
    attr_accessor :options

    def initialize(collections, filename, columns, opts)
      self.collections = collections
      self.filename = filename
      self.columns = columns
      self.options = OpenStruct.new(opts)
    end

    def export
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet :name => 'Sheet1'

      current_row = 0
      if self.options.header
        columns.each_with_index do |column, index|
          sheet.row(current_row).insert index, collections.human_attribute_name(column)
        end
        current_row += 1
      end

      collections.all.each do |resource|
        columns.each_with_index do |column, index|
          record = resource.send(column)
          record = record.strftime("%Y-%m-%d(%H:%m:%S)") if record.respond_to?(:strftime)
          record = number_to_currency(record) if options.krw.include?(column)
          sheet.row(current_row).insert index, record
        end
        current_row = current_row + 1
      end

      book.write filename
      filename
    end
  end
end