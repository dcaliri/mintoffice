require 'iconv'

class BankTransaction < ActiveRecord::Base
  belongs_to :bank_account

  def self.open_and_parse_stylesheet(upload)
    name =  upload['file'].original_filename
    directory = "tmp"
    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(upload['file'].read) }
    parse_stylesheet(path)
    File.delete(path)
  end

  def self.parse_stylesheet(file)
    sheet = Excel.new(file)
    2.upto(sheet.last_row) do |i|
      params = {
        "transacted_at" => sheet.cell(i, 1),
        "transaction_type" => sheet.cell(i, 2),
        "in" => sheet.cell(i, 3),
        "out" => sheet.cell(i, 4),
        "note" => sheet.cell(i, 5),
        "remain" => sheet.cell(i, 6),
        "branchname" => sheet.cell(i, 7)
      }

      logger.info params

      transactions = where(transacted_at: Time.zone.parse(params["transacted_at"]), in: params["in"], out: params["out"], remain: params["remain"])
      if transactions.empty?
        create!(params)
      else
        transaction = transactions.first
        transaction.update_attributes!(params)
      end
    end
  end
end