module ResourceExportable
  class ExcelExporter
    attr_accessor :collections
    attr_accessor :options

    def initialize(collections, opts)
      self.collections = collections
      self.options = OpenStruct.new(opts)
    end

    def export
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet :name => 'Sheet1'

      options.columns.each_with_index do |column, index|
        sheet.row(0).insert index, collections.human_attribute_name(column)
      end

      current_row = 0
      collections.all.each do |resource|
        current_row = current_row + 1
        options.columns.each_with_index do |column, index|
          record = resource.send(column)
          record = record.strftime("%Y-%m-%d(%H:%m:%S)") if record.respond_to?(:strftime)
          sheet.row(current_row).insert index, record
        end
      end

      book.write options.filename
      options.filename
    end
  end
end