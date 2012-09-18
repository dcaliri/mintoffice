# encoding: UTF-8

module CardHistoriesHelper
  def options_for_raw_card_histories_select
    collection = [
      ["신한카드 이용내역", :shinhan_card_used_histories],
      ["현대카드 이용내역", :hyundai_card_used_histories],
      ["신한카드 승인내역", :shinhan_card_approved_histories],
      ["현대카드 승인내역", :hyundai_card_approved_histories],
      ["해외카드 승인내역", :oversea_card_approved_histories],
    ]

    options_for_select(collection, controller_name)
  end
end