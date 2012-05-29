module StylesheetExportable
  extend ActiveSupport::Concern
  EXCEPT = ["id", "bank_account_id", "creditcard_id", "created_at", "updated_at"]

  module ClassMethods
    def export_xls
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet :name => 'Sheet1'

      columns = column_names - EXCEPT

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

      filename = "/tmp/#{table_name}_#{Time.now.utc.strftime("%Y%m%d%H%M%S")}#{User.current_user.id}.xls"
      book.write filename
      filename
    end
  end

  included do
    extend ClassMethods
  end
end