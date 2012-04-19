require 'iconv'

class BankTransaction < ActiveRecord::Base
  def self.parse_stylesheet(file)
    sheet = Excel.new(file)
    1.upto(sheet.last_row - 1) do
      create! do |t|
        t.transacted_at = sheet.cell(2, 1)
        t.transaction_type = sheet.cell(2, 2)
        t.in = sheet.cell(2, 3)
        t.out = sheet.cell(2, 4)
        t.note = sheet.cell(2, 5)
        t.remain = sheet.cell(2, 6)
        t.branchname = sheet.cell(2, 7)
      end
    end
  end
end