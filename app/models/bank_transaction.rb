require 'iconv'

class BankTransaction < ActiveRecord::Base
  def self.open_and_parse_stylesheet(upload)
    name =  upload['file'].original_filename
    directory = "public"
    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(upload['file'].read) }
    parse_stylesheet(path)
  end

  def self.parse_stylesheet(file)
    sheet = Excel.new(file)
    2.upto(sheet.last_row - 1) do |i|
      create! do |t|
        t.transacted_at = sheet.cell(i, 1)
        t.transaction_type = sheet.cell(i, 2)
        t.in = sheet.cell(i, 3)
        t.out = sheet.cell(i, 4)
        t.note = sheet.cell(i, 5)
        t.remain = sheet.cell(i, 6)
        t.branchname = sheet.cell(i, 7)
      end
    end
  end
end