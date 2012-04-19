require 'iconv'

class BankTransfer < ActiveRecord::Base
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
        "transfer_type" => sheet.cell(i, 1),
        "transfered_at" => sheet.cell(i, 2),
        "result" => sheet.cell(i, 3),
        "out_bank_account" => sheet.cell(i, 4),
        "in_bank_name" => sheet.cell(i, 5),
        "in_bank_account" => sheet.cell(i, 6),
        "money" => sheet.cell(i, 7),
        "transfer_fee" => sheet.cell(i, 8),
        "error_money" => sheet.cell(i, 9),
        "registered_at" => sheet.cell(i, 10),
        "error_code" => sheet.cell(i, 11),
        "transfer_note" => sheet.cell(i, 12),
        "incode" => sheet.cell(i, 13),
        "out_account_note" => sheet.cell(i, 14),
        "in_account_note" => sheet.cell(i, 15),
        "in_person_name" => sheet.cell(i, 16)
      }

      logger.info params

      transfers = where(transfer_type: params["transfer_type"], transfered_at: Time.zone.parse(params["transfered_at"]))
      if transfers.empty?
        create!(params)
      else
        transfer = transfers.first
        transfer.update_attributes!(params)
      end
    end
  end
end