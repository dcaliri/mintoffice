module Excels
  module CardApprovedSourcesOverseaInfo
    extend ActiveSupport::Concern

    EXCEL_COLUMNS ||= {}
    EXCEL_COLUMNS[:card_approved_sources_oversea] = [
      :used_at,
      :approve_no,
      :card_no,
      :card_holder_name,
      :store_name,
      :money,

      :money_foreign,
      :money_type,
      :money_type_info,
      :money_dollar,

      :used_type,
      :card_type,
      :canceled_at,
      :status,
      :will_be_paied_at
    ]

    EXCEL_KEYS ||= {}
    EXCEL_KEYS[:card_approved_sources_oversea] = {
      :approve_no => :integer
    }

    EXCEL_OPTIONS ||= {}
    EXCEL_OPTIONS[:card_approved_sources_oversea] = {
      :position => {
        :start => {
          x: 2,
          y: 1
        },
        :end => 0
      }
    }

    module ClassMethods
      def approved_sources_oversea_parser
        parser = ExcelParser.new
        parser.class_name CardApprovedSource
        parser.column EXCEL_COLUMNS[:card_approved_sources_oversea]
        parser.key EXCEL_KEYS[:card_approved_sources_oversea]
        parser.option EXCEL_OPTIONS[:card_approved_sources_oversea]
        parser
      end
    end

    included do
      extend ClassMethods
    end
  end
end