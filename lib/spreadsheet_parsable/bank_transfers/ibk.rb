# encoding: UTF-8

module SpreadsheetParsable
  module BankTransfers
    module Ibk
      extend ActiveSupport::Concern

      IBK = {
        :name => :ibk,
        :keys => {
          :transfer_type => :integer,
          :transfered_at => :time,
        },
        :columns => {
          :transfer_type      => "거래구분",
          :registered_at      => "등록일자",
          :transfered_at      => "이체일시",
          :result             => "거래상태",
          :out_bank_account   => "출금계좌번호",
          :money              => "이체금액",
          :transfer_fee       => "이체수수료",
          :in_bank_name       => "입금은행",
          :in_bank_account    => "입금계좌번호",
          :out_account_note   => "받는 분 통장에 표시할 내용",
          :in_account_note    => "내 통장에 표시할 내용",
          :in_person_name     => "예금주명",
          :cms_code           => "CMS코드",
          :currency_code      => "통화코드",
        },
        :position => {
          :start => {
            x: 7,
            y: 2
          },
          :end => -1
        }
      }

      module ClassMethods
        def ibk_bank_transfer_parser
          parser = ExcelParser.new
          parser.class_name BankTransfer
          parser.column IBK[:columns]
          parser.key IBK[:keys]
          parser.option :position => IBK[:position]
          parser
        end
      end

      included do
        extend ClassMethods
      end
    end
  end
end